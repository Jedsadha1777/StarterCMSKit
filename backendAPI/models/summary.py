from extensions import db


class Summary(db.Model):
    __tablename__ = 'summary'

    table_name = db.Column(db.String(64), primary_key=True)
    row_count = db.Column(db.Integer, nullable=False, default=0)
    updated_at = db.Column(db.DateTime)
