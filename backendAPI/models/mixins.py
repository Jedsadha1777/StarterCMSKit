from passlib.hash import bcrypt


class PasswordMixin:
    """Shared password hashing for Admin and User models."""

    def set_password(self, password):
        self.password_hash = bcrypt.hash(password)

    def check_password(self, password):
        return bcrypt.verify(password, self.password_hash)
