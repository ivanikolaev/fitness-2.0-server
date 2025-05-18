-- Create enum types
CREATE TYPE user_role AS ENUM ('user', 'trainer', 'admin');
CREATE TYPE muscle_group AS ENUM ('chest', 'back', 'shoulders', 'arms', 'legs', 'core', 'full_body', 'cardio');
CREATE TYPE exercise_type AS ENUM ('strength', 'cardio', 'flexibility', 'balance');

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role user_role NOT NULL DEFAULT 'user',
  profile_picture VARCHAR(255),
  height NUMERIC,
  weight NUMERIC,
  date_of_birth DATE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  refresh_token TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create exercises table
CREATE TABLE IF NOT EXISTS exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  primary_muscle_group muscle_group NOT NULL DEFAULT 'full_body',
  type exercise_type NOT NULL DEFAULT 'strength',
  image_url VARCHAR(255),
  video_url VARCHAR(255),
  instructions TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create workouts table
CREATE TABLE IF NOT EXISTS workouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  scheduled_date TIMESTAMP WITH TIME ZONE NOT NULL,
  completed_date TIMESTAMP WITH TIME ZONE,
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  duration INTEGER NOT NULL DEFAULT 0,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create workout_exercises table
CREATE TABLE IF NOT EXISTS workout_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workout_id UUID NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES exercises(id),
  "order" INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create exercise_sets table
CREATE TABLE IF NOT EXISTS exercise_sets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workout_exercise_id UUID NOT NULL REFERENCES workout_exercises(id) ON DELETE CASCADE,
  set_number INTEGER NOT NULL DEFAULT 1,
  weight NUMERIC,
  reps INTEGER,
  duration INTEGER, -- in seconds
  distance NUMERIC, -- in kilometers
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_workouts_user_id ON workouts(user_id);
CREATE INDEX idx_workout_exercises_workout_id ON workout_exercises(workout_id);
CREATE INDEX idx_workout_exercises_exercise_id ON workout_exercises(exercise_id);
CREATE INDEX idx_exercise_sets_workout_exercise_id ON exercise_sets(workout_exercise_id);

-- Add some sample data for testing

-- Sample exercises
INSERT INTO exercises (name, description, primary_muscle_group, type, instructions)
VALUES 
  ('Bench Press', 'Compound exercise for chest, shoulders, and triceps', 'chest', 'strength', 'Lie on a bench, lower the bar to your chest, then push it back up'),
  ('Squat', 'Compound exercise for legs and core', 'legs', 'strength', 'Stand with feet shoulder-width apart, lower your body by bending your knees, then return to standing'),
  ('Deadlift', 'Compound exercise for back, legs, and core', 'back', 'strength', 'Stand with feet hip-width apart, bend at the hips and knees to grip the bar, then stand up straight'),
  ('Pull-up', 'Upper body compound exercise', 'back', 'strength', 'Hang from a bar with palms facing away, pull your body up until your chin is over the bar'),
  ('Running', 'Cardiovascular exercise', 'cardio', 'cardio', 'Run at a steady pace for the desired duration'),
  ('Plank', 'Core stabilization exercise', 'core', 'strength', 'Hold a push-up position with your body in a straight line from head to heels'),
  ('Overhead Press', 'Shoulder press with barbell or dumbbells', 'shoulders', 'strength', 'Press weight overhead until arms are extended, then lower slowly'),
  ('Barbell Row', 'Bent-over row for back development', 'back', 'strength', 'Bend at waist, pull barbell to torso while keeping back straight'),
  ('Bicep Curl', 'Isolation exercise for biceps', 'arms', 'strength', 'Curl weight up while keeping elbows stationary, then lower slowly'),
  ('Tricep Dip', 'Bodyweight exercise for triceps', 'arms', 'strength', 'Lower body by bending elbows, then push back up'),
  ('Lunges', 'Unilateral leg exercise', 'legs', 'strength', 'Step forward and lower until both knees are bent at 90 degrees'),
  ('Lat Pulldown', 'Machine exercise for latissimus dorsi', 'back', 'strength', 'Pull bar down to chest while keeping torso upright'),
  ('Leg Press', 'Machine compound leg exercise', 'legs', 'strength', 'Press weight away with legs while keeping back flat against pad'),
  ('Calf Raise', 'Isolation exercise for calves', 'legs', 'strength', 'Raise heels off ground by extending ankles, then lower slowly'),
  ('Russian Twist', 'Rotational core exercise', 'core', 'strength', 'Rotate torso side to side while holding weight'),
  ('Hanging Leg Raise', 'Advanced core exercise', 'core', 'strength', 'Hang from bar and raise legs until parallel to ground'),
  ('Burpees', 'Full-body conditioning exercise', 'full_body', 'strength', 'Squat, kick legs back, do pushup, jump up'),
  ('Jump Rope', 'Cardio coordination exercise', 'cardio', 'cardio', 'Jump continuously while swinging rope'),
  ('Cycling', 'Low-impact cardio exercise', 'cardio', 'cardio', 'Pedal continuously at desired intensity'),
  ('Swimming', 'Full-body cardio exercise', 'full_body', 'cardio', 'Swim laps using preferred stroke'),
  ('Yoga', 'Mind-body flexibility practice', 'full_body', 'flexibility', 'Perform series of poses with controlled breathing'),
  ('Push-up', 'Bodyweight chest exercise', 'chest', 'strength', 'Lower body until chest nearly touches ground, then push up'),
  ('Incline Bench Press', 'Upper chest variation', 'chest', 'strength', 'Perform bench press on incline bench'),
  ('Hammer Curl', 'Bicep exercise with neutral grip', 'arms', 'strength', 'Curl dumbbells with palms facing each other'),
  ('Face Pull', 'Rear delt and upper back exercise', 'shoulders', 'strength', 'Pull rope toward face while retracting shoulder blades'),
  ('Side Plank', 'Core stability exercise', 'core', 'strength', 'Hold body in straight line while balancing on one arm'),
  ('Box Jump', 'Plyometric leg exercise', 'legs', 'strength', 'Jump onto box from standing position'),
  ('Farmer''s Walk', 'Grip and core exercise', 'full_body', 'strength', 'Walk while holding heavy weights at sides'),
  ('Battle Ropes', 'Cardio and upper body endurance', 'full_body', 'cardio', 'Create waves with heavy ropes continuously'),
  ('Turkish Get-up', 'Full-body functional exercise', 'full_body', 'strength', 'Move from lying to standing while holding weight overhead');

-- Sample user (password is 'password' hashed)
INSERT INTO users (first_name, last_name, email, password, role)
VALUES 
  ('John', 'Doe', 'john@example.com', '$2b$10$XeHgCDKKOaZuQxuWcKS93ujdRjn6zVT0INh0IG1jWb8I2OY9DNyTS', 'user'),
  ('Admin', 'User', 'admin@example.com', '$2b$10$XeHgCDKKOaZuQxuWcKS93ujdRjn6zVT0INh0IG1jWb8I2OY9DNyTS', 'admin');
