from uuid import uuid4
from extensions import db
from datetime import datetime, timezone


# Many-to-many join table: MachineModel <-> InspectionItem
machine_model_inspection_items = db.Table(
    'machine_model_inspection_items',
    db.Column('machine_model_id', db.Integer, db.ForeignKey('machine_models.id', ondelete='CASCADE'), nullable=False),
    db.Column('inspection_item_id', db.Integer, db.ForeignKey('inspection_items.id', ondelete='CASCADE'), nullable=False),
    db.PrimaryKeyConstraint('machine_model_id', 'inspection_item_id'),
)


class MachineModel(db.Model):
    __tablename__ = 'machine_models'

    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.String(36), unique=True, nullable=False, default=lambda: str(uuid4()))
    model_code = db.Column(db.String(50), nullable=False)
    model_name = db.Column(db.String(200), nullable=False)
    company_id = db.Column(db.Integer, db.ForeignKey('companies.id', ondelete='CASCADE'), nullable=True, index=True)
    created_by = db.Column(db.Integer, db.ForeignKey('admins.id', ondelete='SET NULL'), nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None))
    updated_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc).replace(tzinfo=None), onupdate=lambda: datetime.now(timezone.utc).replace(tzinfo=None))

    creator = db.relationship('Admin', backref='machine_models', lazy=True, foreign_keys=[created_by])
    inspection_items = db.relationship('InspectionItem', secondary=machine_model_inspection_items, backref='machine_models')

    __table_args__ = (
        db.UniqueConstraint('company_id', 'model_code', name='uq_machine_model_company_code'),
    )

    def to_dict(self):
        return {
            'id': self.public_id,
            'model_code': self.model_code,
            'model_name': self.model_name,
            'inspection_items': [item.to_dict() for item in self.inspection_items],
            'created_by': self.creator.public_id if self.creator else None,
            'created_by_name': self.creator.name if self.creator else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
