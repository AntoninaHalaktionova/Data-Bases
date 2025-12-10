from model import Model
from view import View

class Controller:
    def __init__(self):
        self.model = Model()
        self.view = View()

    def run(self):
        while True:
            choice = self.view.show_menu()

            if choice == '1':
                docs = self.model.get_all_doctors()
                self.view.show_doctors(docs)

            elif choice == '2':
                try:
                    data = self.view.get_patient_input()
                    self.model.add_patient(*data)
                except Exception as e:
                    self.view.show_message(f"Error: {e}")

            elif choice == '3':
                id = self.view.get_delete_id()
                self.model.delete_doctor(id)

            elif choice == '4':
                try:
                    cnt = self.view.get_generation_count()
                    self.view.show_message("Generating data...")
                    self.model.generate_data(cnt)
                except ValueError:
                    self.view.show_message("Please enter a number!")

            elif choice == '5':
                params = self.view.get_search_params()
                res, t = self.model.search_visits(*params)
                self.view.show_search_results(res, t)

            elif choice == '0':
                break
            else:
                self.view.show_message("Wrong choice.")