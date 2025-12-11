from sqlalchemy import create_engine, Column, Integer, String, Date, ForeignKey, ARRAY
from sqlalchemy.orm import declarative_base, relationship, sessionmaker
import datetime

# Підключення до бази даних
DATABASE_URI = 'postgresql+psycopg2://postgres:1@localhost:5432/hospital_lab2'
engine = create_engine(DATABASE_URI)
Base = declarative_base()

# --- Моделі ---
class Patient(Base):
    __tablename__ = 'patient'
    
    patient_id = Column(Integer, primary_key=True)
    full_name = Column(String(255), nullable=False)
    date_of_birth = Column(Date, nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    gender = Column(String(20), nullable=False)

    visits = relationship("Visit", back_populates="patient", cascade="all, delete")

class Doctor(Base):
    __tablename__ = 'doctor'

    doctor_id = Column(Integer, primary_key=True)
    full_name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    specialization = Column(String(255), nullable=False)

    visits = relationship("Visit", back_populates="doctor")

class Visit(Base):
    __tablename__ = 'visit'

    visit_id = Column(Integer, primary_key=True)
    patient_id = Column(Integer, ForeignKey('patient.patient_id'), nullable=False)
    doctor_id = Column(Integer, ForeignKey('doctor.doctor_id'), nullable=False)
    date = Column(Date, nullable=False)
    diagnosis = Column(String(255), nullable=False)
    symptoms = Column(ARRAY(String), nullable=True) 

    patient = relationship("Patient", back_populates="visits")
    doctor = relationship("Doctor", back_populates="visits")

# --- Main ---
if __name__ == "__main__":
    # Створення таблиць
    Base.metadata.create_all(engine)
    print("Таблиці перевірено/створено.")

    Session = sessionmaker(bind=engine)
    session = Session()

    # Заповнення даними, якщо таблиця пуста
    if not session.query(Doctor).first():
        doc = Doctor(full_name="Dr. House", email="house@md.com", specialization="Diagnostician")
        pat = Patient(full_name="Ivan Petrenko", date_of_birth=datetime.date(1990, 5, 20), email="ivan@test.com", gender="Male")

        session.add(doc)
        session.add(pat)
        session.commit()

        visit = Visit(
            patient_id=pat.patient_id, 
            doctor_id=doc.doctor_id, 
            date=datetime.date.today(), 
            diagnosis="Flu", 
            symptoms=["cough", "fever"]
        )
        session.add(visit)
        session.commit()
        print("Тестові дані додано.")
    else:
        print("Дані вже існують.")

    # Вибірка
    print("\nСписок візитів:")
    visits = session.query(Visit).all()
    for v in visits:
        print(f"ID: {v.visit_id} | Пацієнт: {v.patient.full_name} | Діагноз: {v.diagnosis}")