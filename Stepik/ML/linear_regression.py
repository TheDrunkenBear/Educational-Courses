from typing import Optional, Union, Literal
import pandas as pd
import numpy as np


class MyLineReg:
    n_iter: Optional[int] = 100
    """Количество итераций градиентного спуска"""

    learning_rate: Optional[float] = 0.1
    """Шаг градиентного спуска"""

    weights: Optional[list] = None
    """Весовые коэффициенты линейной модели"""

    metric: Optional[Literal["mae", "mse", "rmse", "mape", "r2"]] = None
    """Метрика качества модели"""

    _best_score: Optional[float] = None
    """Лучшее значение метрики качества модели"""

    def __init__(self, **kwargs) -> None:
        """Инициализация параметров класса MyLineReg"""
        self.n_iter = kwargs.get("n_iter", self.n_iter)
        self.learning_rate = kwargs.get("learning_rate", self.learning_rate)
        self.metric = kwargs.get("metric", self.metric)

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

        for iteration in range(self.n_iter + 1):
            y_pred = self._predict(X)
            mse = np.mean((y_pred - y) ** 2)

            # Вычисление градиента
            gradient = 2 / observation_count * np.dot(X.T, (y_pred - y))

            # Обновление весов
            self.weights -= self.learning_rate * gradient

            # Вычисление и сохранение лучшего значения метрики качества модели
            self._best_score = {
                "mae": np.mean(np.abs(y - y_pred)),
                "rmse": np.sqrt(mse),
                "mse": mse,
                "r2": 1 - (np.sum((y - y_pred) ** 2) / np.sum((y - np.mean(y)) ** 2)),
                "mape": np.mean(np.abs((y - y_pred) / y)) * 100,
            }.get(self.metric)

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

    def get_best_score(self) -> Optional[float]:
        """Получение лучшего значения метрики качества модели

        Returns:
            Optional[float]: Лучшее значение метрики качества модели
        """
        return self._best_score
