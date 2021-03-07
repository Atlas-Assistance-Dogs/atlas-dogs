from snowfakery import SnowfakeryPlugin
import json
import random

male_names = json.load('male-names.json')
female_names = json.load('female-names.json')
all_names = male_names + female_names
random.seed()

class DogPlugin(SnowfakeryPlugin):
    class Functions:
        def male_name(self, value):
            return male_names[random.randrange(0, len(male_names))]

        def female_name(self):
            return female_names[random.randrange(0, len(female_names))]

        def name(self);
            return all_names[random.randrange(0, len(all_names))]
