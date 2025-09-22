from typing import Optional, Union
import pandas as pd
import numpy as np


class MyLogReg:
    n_iter: Optional[int] = 10
    """Количество итераций градиентного спуска"""

    learning_rate: Optional[float] = 0.1
    """Шаг градиентного спуска"""

    weights: Optional[list] = None
    """Весовые коэффициенты линейной модели"""

    _eps: float = 1e-15

    def __init__(self, **kwargs):
        """Инициализация параметров класса MyLineReg"""
        self.n_iter = kwargs.get("n_iter", self.n_iter)
        self.learning_rate = kwargs.get("learning_rate", self.learning_rate)

    def __str__(self):
        """Строковое представление объекта класса MyLogReg"""
        return (
            f"MyLogReg class: n_iter={self.n_iter}, learning_rate={self.learning_rate}"
        )

    def _predict(self, X: pd.DataFrame) -> np.ndarray:
        """Внутренний метод для предсказания значений целевой переменной

        Args:
            X (pd.DataFrame): Матрица объекты-признаки

        Returns:
            np.ndarray: Вектор предсказанных значений целевой переменной
        """
        return 1 / (1 + np.exp(-np.dot(X, self.weights)))

    def fit(self, X: pd.DataFrame, y: pd.Series, verbose: Union[int, bool]) -> None:
        """Обучение логистической модели методом градиентного спуска

        Args:
            X (pd.DataFrame): Матрица объекты-признаки
            y (pd.Series): Вектор целевой переменной
            verbose (Union[int, bool], optional): Параметр для вывода промежуточных результатов. Defaults to False.
        """

        # Добавление столбца для свободного члена
        X.insert(0, "bias", 1)
        observation_count, feature_count = X.shape

        # Инициализация весов единицами
        self.weights = np.ones(feature_count)

        for iteration in range(self.n_iter + 1):
            y_pred = self._predict(X)
            log_loss = (
                (-1)
                / observation_count
                * np.sum(
                    y * np.log(y_pred + self._eps)
                    + (1 - y) * np.log(1 - y_pred + self._eps)
                )
            )

            # Вычисление градиента
            gradient = 1 / observation_count * np.dot(X.T, (y_pred - y))

            # Обновление весов
            self.weights -= self.learning_rate * gradient

            if verbose:
                if isinstance(verbose, int):
                    if iteration % verbose == 0:
                        print(
                            f"Iteration {iteration}, {self.metric.title}: {self._best_score}"
                        )

    def get_coef(self) -> Optional[list]:
        """Получение весовых коэффициентов линейной модели

        Returns:
            Optional[list]: Весовые коэффициенты линейной модели
        """
        return self.weights[1:]

    def predict_proba(self, X: pd.DataFrame) -> float:
        """Предсказание значений целевой переменной

        Args:
            X (pd.DataFrame): Матрица объекты-признаки

        Returns:
            float: Вектор предсказанных значений целевой переменной
        """
        X.insert(0, "bias", 1)
        return np.mean(self._predict(X))

    def predict(self, X: pd.DataFrame) -> int:
        """Предсказание вероятностей положительного класса

        Args:
            X (pd.DataFrame): Матрица объекты-признаки

        Returns:
            float: Вектор предсказанных вероятностей положительного класса
        """
        X.insert(0, "bias", 1)
        return np.sum(self._predict(X) > 0.5)
