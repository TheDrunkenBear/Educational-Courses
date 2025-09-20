from typing import Optional


class MyLineReg:
    n_iter: Optional[int] = None
    """Количество итераций градиентного спуска"""

    learning_rate: Optional[float] = None
    """Шаг градиентного спуска"""

    def __init__(self, **kwargs) -> None:
        self.n_iter = kwargs.get("n_iter", 100)
        self.learning_rate = kwargs.get("learning_rate", 0.1)

    def __str__(self):
        return f"MyLineReg class: n_iter={self.n_iter}, learning_rate={self.learning_rate}"
