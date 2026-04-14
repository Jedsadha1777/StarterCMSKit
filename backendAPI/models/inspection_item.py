from uuid import uuid4
from extensions import db
from datetime import datetime, timezone


class InspectionItem(db.Model):
    __tablename__ = 'inspection_items'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    item_code = db.Column(db.String(50), unique=True, nullable=False)
    item_name = db.Column(db.String(200), nullable=False)
    spec = db.Column(db.String(255), nullable=True)
    created_by = db.Column(db.Integer, db.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    creator = db.relationship('Admin', backref='inspection_items', lazy=True, foreign_keys=[created_by])

    def to_dict(self):
        return {
            'id': self.public_id,
            'item_code': self.item_code,
            'item_name': self.item_name,
            'spec': self.spec,
            'created_by': self.creator.public_id if self.creator else None,
            'created_by_name': self.creator.name if self.creator else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
