from typing import Optional, Union
import pandas as pd
import numpy as np


class MyLineReg:
    n_iter: Optional[int] = 100
    """Количество итераций градиентного спуска"""

    learning_rate: Optional[float] = 0.1
    """Шаг градиентного спуска"""

    weights: Optional[list] = None
    """Весовые коэффициенты линейной модели"""

    def __init__(self, **kwargs) -> None:
        """Инициализация параметров класса MyLineReg"""
        self.n_iter = kwargs.get("n_iter", self.n_iter)
        self.learning_rate = kwargs.get("learning_rate", self.learning_rate)

    def __str__(self):
        """Строковое представление объекта класса MyLineReg"""
        return (
            f"MyLineReg class: n_iter={self.n_iter}, learning_rate={self.learning_rate}"
        )

    def _predict(self, X: pd.DataFrame) -> np.ndarray:
        """Внутренний метод для предсказания значений целевой переменной

        Args:
            X (pd.DataFrame): Матрица объекты-признаки

        Returns:
            np.ndarray: Вектор предсказанных значений целевой переменной
        """
        return np.dot(X, self.weights)

    def fit(
        self, X: pd.DataFrame, y: pd.Series, verbose: Union[int, bool] = False
    ) -> None:
        """Обучение линейной модели методом градиентного спуска

        Args:
            X (pd.DataFrame): Матрица объекты-признаки
            y (pd.Series): Вектор целевой переменной
            verbose (Union[int, bool], optional): Параметр для вывода промежуточных результатов. Defaults to False.
        """
        # Добавление столбца для свободного члена
        X.insert(0, "bias", 1)
        observation_count, feature_count = X.shape

        # Инициализация весов нулями
        self.weights = np.ones(feature_count)

        y_pred = self._predict(X)
        mse = np.mean((y_pred - y) ** 2)

        for iteration in range(self.n_iter):
            y_pred = self._predict(X)
            mse = np.mean((y_pred - y) ** 2)

            # Вычисление градиента
            gradient = 2 / observation_count * np.dot(X.T, (y_pred - y))

            # Обновление весов
            self.weights -= self.learning_rate * gradient

            if verbose:
                if isinstance(verbose, int):
                    if iteration % verbose == 0:
                        print(f"Iteration {iteration}, MSE: {mse}")

    def get_coef(self) -> Optional[list]:
        """Получение весовых коэффициентов линейной модели

        Returns:
            Optional[list]: Весовые коэффициенты линейной модели
        """
        return self.weights[1:]


if __name__ == "__main__":
    # Пример использования класса MyLineReg
    from sklearn.datasets import make_regression

    X, y = make_regression(
        n_samples=1000, n_features=14, n_informative=10, noise=15, random_state=42
    )
    X = pd.DataFrame(X)
    y = pd.Series(y)
    X.columns = [f"col_{col}" for col in X.columns]

    model = MyLineReg(n_iter=50, learning_rate=0.1)
    model.fit(X, y, verbose=10)
    print(np.mean(model.get_coef()))
