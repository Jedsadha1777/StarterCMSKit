from uuid import uuid4
from extensions import db
from datetime import datetime, timezone


class ImportHistory(db.Model):
    __tablename__ = 'import_histories'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    resource_type = db.Column(db.String(50), nullable=False, default='')
    original_filename = db.Column(db.String(255), nullable=False)
    stored_filename = db.Column(db.String(255), nullable=False)
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='CASCADE'), nullable=True, index=True)
    imported_by = db.Column(db.Integer, db.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    importer = db.relationship('Admin', backref='import_histories', lazy=True, foreign_keys=[imported_by])

    def to_dict(self):
        return {
            'id': self.public_id,
            'resource_type': self.resource_type,
            'original_filename': self.original_filename,
            'imported_by': self.importer.public_id if self.importer else None,
            'imported_by_name': self.importer.name if self.importer else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }
