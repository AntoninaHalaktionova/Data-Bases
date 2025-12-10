class View:
    def show_menu(self):
        print("\n--- MENU ---")
        print("1. Список лікарів")
        print("2. Додати пацієнта")
        print("3. Видалити лікаря (ID)")
        print("4. Генерація даних")
        print("5. Пошук візитів")
        print("0. Вихід")
        return input(" > ")

    def show_doctors(self, doctors):
        print("\n--- Лікарі ---")
        for d in doctors:
            # d[0]=id, d[1]=name, d[2]=spec
            print(f"ID: {d[0]} | {d[1]} | {d[2]}")

    def get_patient_input(self):
        print("\n--- Новий пацієнт ---")
        name = input("ПІБ: ")
        dob = input("Дата народження (YYYY-MM-DD): ")
        email = input("Email: ")
        gender = input("Стать (female/male): ")
        return name, dob, email, gender

    def get_delete_id(self):
        return input("Введіть ID лікаря: ")

    def get_generation_count(self):
        return int(input("Кількість записів (напр. 1000): "))

    def get_search_params(self):
        print("\n--- Параметри пошуку ---")
        diag = input("Діагноз (можна частину): ")
        d_from = input("Дата з (2020-01-01): ")
        d_to = input("Дата по (2030-12-31): ")
        return diag, d_from, d_to

    def show_message(self, msg):
        print(f"\n[INFO]: {msg}")

    def show_search_results(self, res, time_ms):
        print(f"\nРезультат: {len(res)} записів (Час: {time_ms:.2f} мс)")
        print("-" * 40)
        for row in res:
            # row: date, diagnosis, pat_name, doc_name
            print(f"Дата: {row[1]} | {row[3]} -> {row[4]}")
            print(f"Діагноз: {row[2]}")
            print("-" * 40)