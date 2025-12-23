import '../bloc/nutrition_plan_cubit.dart';

const dummyDietaryPlan = DietaryPlan(
  goal: 'Weight loss',
  strategy: 'Low-carb, high-protein',
  dailyCaloryTarget: 1800,
  recommendedFoods: [
    'Chicken breast, eggs, salmon',
    'Leafy greens, broccoli',
    'Chia seeds, almonds',
    'Greek yogurt (unsweetened)',
  ],
  foodsToLimit: [
    'White bread, rice, pasta',
    'Sweetened beverages',
    'Fried foods',
  ],
);

const dummySupplements = [
  Supplement(name: 'Probiotics Complex', dosage: '1 daily with meal'),
  Supplement(name: 'Omega-3 (Fish Oi l)', dosage: '2 capsules after breakfast'),
  Supplement(name: 'Vitamin D', dosage: 'once weekly'),
];

const dummyLifestyleAdjustments = [
  LifestyleAdjustment(
      title: 'Target: 7-8 hrs/night',
      description: 'No screens 30 mins before bed'),
  LifestyleAdjustment(
      title: 'Daily Breathing Practice',
      description: 'Use calm/headspace app'),
  LifestyleAdjustment(
      title: 'Brisk Walking 4x/week', description: '30 mins'),
];

final dummyWeeklyMealPlan = {
  'Monday': const DailyMealPlan(
    breakfast: [
      FoodItem(
          name: 'Tuna Salad',
          imageUrl: 'https://i.imgur.com/ZrEnTyG.png',
          calories: 294,
          grams: 100,
          protein: 25,
          carbs: 32,
          fat: 17),
      FoodItem(
          name: 'Oatmeal',
          imageUrl: 'https://i.imgur.com/NXCm0pc.png',
          calories: 157,
          grams: 100,
          protein: 15,
          carbs: 22,
          fat: 7),
      FoodItem(
          name: 'Pancakes',
          imageUrl: 'https://i.imgur.com/3m7THGu.png',
          calories: 317,
          grams: 100,
          protein: 20,
          carbs: 47,
          fat: 5),
    ],
    lunch: [
      FoodItem(
          name: 'Grilled Chicken Salad',
          imageUrl:
              'https://hips.hearstapps.com/hmg-prod/images/grilled-chicken-salad-lead-6628169550105.jpg?resize=1800:*',
          calories: 350,
          grams: 150,
          protein: 40,
          carbs: 10,
          fat: 18),
    ],
    dinner: [
      FoodItem(
          name: 'Baked Salmon',
          imageUrl:
              'https://food.fnr.sndimg.com/content/dam/images/food/fullset/2019/12/20/0/FNK_Baked-Salmon_H_s4x3.jpg.rend.hgtvcom.1280.1280.suffix/1576855635102.webp',
          calories: 412,
          grams: 180,
          protein: 45,
          carbs: 5,
          fat: 24),
    ],
  ),
  'Tuesday': const DailyMealPlan(
    breakfast: [
      FoodItem(
          name: 'Oatmeal',
          imageUrl:
              'https://food.fnr.sndimg.com/content/dam/images/food/fullset/2019/12/20/0/FNK_Baked-Salmon_H_s4x3.jpg.rend.hgtvcom.1280.1280.suffix/1576855635102.webp',
          calories: 157,
          grams: 100,
          protein: 15,
          carbs: 22,
          fat: 7),
    ],
  ),
  'Wednesday': const DailyMealPlan(),
  'Thursday': const DailyMealPlan(),
  'Friday': const DailyMealPlan(),
  'Saturday': const DailyMealPlan(),
  'Sunday': const DailyMealPlan(),
};
