from uuid import uuid4
from extensions import db
from datetime import datetime, timezone

class Article(db.Model):
    __tablename__ = 'articles'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text, nullable=False)
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='CASCADE'), nullable=True, index=True)
    admin_id = db.Column(db.Integer, db.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True, index=True)
    status = db.Column(db.String(20), nullable=False, default='draft')
    publish_date = db.Column(db.DateTime, nullable=True)
    version = db.Column(db.Integer, nullable=False, default=1)
    is_deleted = db.Column(db.Boolean, nullable=False, default=False)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    
    def to_dict(self):
        return {
            'id': self.public_id,
            'title': self.title,
            'content': self.content,
            'author_id': self.admin_author.public_id if self.admin_author else None,
            'author_email': self.admin_author.email if self.admin_author else None,
            'status': self.status,
            'publish_date': self.publish_date.isoformat() if self.publish_date else None,
            'version': self.version,
            'is_deleted': self.is_deleted,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }