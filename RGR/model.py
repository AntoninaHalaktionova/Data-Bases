import psycopg2
from psycopg2 import Error
import time
from config import DB_CONFIG

class Model:
    def __init__(self):
        self.connection = None
        try:
            self.connection = psycopg2.connect(**DB_CONFIG)
            self.connection.autocommit = True
            print("Connected to DB")
        except (Exception, Error) as error:
            print(f"Error connecting to PostgreSQL: {error}")

    def __del__(self):
        if self.connection:
            self.connection.close()
            print("Connection closed")

    def generate_data(self, count):
        start_time = time.time()
        cursor = self.connection.cursor()
        try:
            print(f"Generating {count} rows...")
            
            # patients
            sql_pat = f"""
            INSERT INTO public.patient ("Full_name", "Date_of_birth", "Email", "Gender")
            SELECT
                (ARRAY['Ivan', 'Petro', 'Oleg', 'Andriy', 'Mykola', 'Maria', 'Olga', 'Anna', 'Yulia', 'Natali'])[floor(random()*10+1)]
                || ' ' ||
                (ARRAY['Ivanov', 'Petrenko', 'Kovalenko', 'Bondar', 'Tkachenko', 'Shevchenko', 'Boyko', 'Melnyk'])[floor(random()*8+1)],
                timestamp '1950-01-01' + random() * (timestamp '2010-01-01' - timestamp '1950-01-01'),
                'user_' || md5(random()::text)::varchar(5) || '_' || generate_series || '@gmail.com',
                CASE WHEN random() > 0.5 THEN 'female' ELSE 'male' END
            FROM generate_series(1, {count});
            """
            cursor.execute(sql_pat)

            # doctors
            doc_count = max(5, count // 20)
            sql_doc = f"""
            INSERT INTO public.doctor ("Full_name", "Email", "Specialization")
            SELECT
                'Dr. ' || (ARRAY['House', 'Watson', 'Strange', 'Dolittle', 'Zhivago', 'Who'])[floor(random()*6+1)],
                'doctor_' || generate_series || '_' || trunc(random()*1000)::text || '@clinic.com',
                (ARRAY['Cardiologist', 'Dermatologist', 'Neurologist', 'Therapist', 'Surgeon'])[floor(random() * 5 + 1)]
            FROM generate_series(1, {doc_count});
            """
            cursor.execute(sql_doc)

            # visits
            sql_visit = f"""
            WITH p_ids AS (SELECT array_agg(patient_id) as ids FROM public.patient),
                 d_ids AS (SELECT array_agg(doctor_id) as ids FROM public.doctor)
            INSERT INTO public.visit (patient_id, doctor_id, date, diagnosis)
            SELECT
                p.ids[floor(random() * array_length(p.ids, 1) + 1)],
                d.ids[floor(random() * array_length(d.ids, 1) + 1)],
                timestamp '2024-01-01' + random() * (timestamp '2025-12-31' - timestamp '2024-01-01'),
                (ARRAY['Flu', 'Migraine', 'Gastritis', 'Bronchitis', 'Hypertension', 'Allergy', 'Dermatitis', 'Arrhythmia'])[floor(random()*8+1)]
            FROM generate_series(1, {count}), p_ids p, d_ids d;
            """
            cursor.execute(sql_visit)

            print(f"Done! Time: {time.time() - start_time:.2f} sec.")

        except (Exception, Error) as error:
            print(f"Gen error: {error}")
        finally:
            cursor.close()

    def search_visits(self, diag, d_from, d_to):
        cursor = self.connection.cursor()
        t_start = time.time()
        try:
            sql = """
                SELECT v.visit_id, v.date, v.diagnosis, p."Full_name", d."Full_name"
                FROM public.visit v
                JOIN public.patient p ON v.patient_id = p.patient_id
                JOIN public.doctor d ON v.doctor_id = d.doctor_id
                WHERE v.diagnosis ILIKE %s
                AND v.date BETWEEN %s AND %s
                LIMIT 100;
            """
            cursor.execute(sql, (f'%{diag}%', d_from, d_to))
            res = cursor.fetchall()
            return res, (time.time() - t_start) * 1000
        except (Exception, Error) as error:
            print(f"Search error: {error}")
            return [], 0
        finally:
            cursor.close()

    def get_all_doctors(self):
        cursor = self.connection.cursor()
        try:
            cursor.execute('SELECT doctor_id, "Full_name", "Specialization" FROM public.doctor ORDER BY doctor_id DESC LIMIT 20')
            return cursor.fetchall()
        finally:
            cursor.close()

    def add_patient(self, name, dob, email, gender):
        cursor = self.connection.cursor()
        try:
            sql = 'INSERT INTO public.patient ("Full_name", "Date_of_birth", "Email", "Gender") VALUES (%s, %s, %s, %s)'
            cursor.execute(sql, (name, dob, email, gender))
            print("Patient added.")
        except Error as e:
            print(f"DB Error: {e}")
        finally:
            cursor.close()

    def delete_doctor(self, doc_id):
        cursor = self.connection.cursor()
        try:
            cursor.execute('DELETE FROM public.doctor WHERE doctor_id = %s', (doc_id,))
            if cursor.rowcount > 0:
                print(f"Doctor {doc_id} deleted.")
            else:
                print("Not found.")
        except psycopg2.errors.ForeignKeyViolation:
            print("Error: Cannot delete doctor because they have patients/visits.")
        except Error as e:
            print(f"Error: {e}")
        finally:
            cursor.close()