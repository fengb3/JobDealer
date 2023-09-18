-- Insert companies
INSERT INTO main.Company (Name, Address, Description, LogoUrl)
VALUES ('Tech Innovators', '123 Innovation Road, San Francisco, CA 94111',
        'A leading technology company focused on innovative solutions', NULL),
       ('Green Energy Solutions', '456 Renewable Street, Austin, TX 78701',
        'A company dedicated to providing renewable energy solutions', NULL),
       ('Healthcare Hub', '789 Medical Parkway, Boston, MA 02114',
        'A top healthcare provider offering a range of services', NULL),
       ('Global Finance Corp', '321 Financial Ave, New York, NY 10001', 'A multinational financial services company',
        NULL),
       ('Creative Design Studios', '654 Artistic Lane, Los Angeles, CA 90012',
        'A design agency focused on creative and unique experiences', NULL);

-- Insert users
INSERT INTO main.User (UserName, Password, TypeMask)
VALUES
-- Job Seekers
('jseeker1', 'password1', 1),
('jseeker2', 'password2', 1),
('jseeker3', 'password3', 1),
('jseeker4', 'password4', 1),
('jseeker5', 'password5', 1),
('jseeker6', 'password6', 1),
('jseeker7', 'password7', 1),
('jseeker8', 'password8', 1),
('jseeker9', 'password9', 1),
('jseeker10', 'password10', 1),
('jseeker11', 'password11', 1),
('jseeker12', 'password12', 1),
('jseeker13', 'password13', 1),
('jseeker14', 'password14', 1),
('jseeker15', 'password15', 1),
-- Job Posters
('jposter1', 'password16', 2),
('jposter2', 'password17', 2),
('jposter3', 'password18', 2),
('jposter4', 'password19', 2),
('jposter5', 'password20', 2);

-- Insert persons
INSERT INTO main.Person (UserId, FirstName, LastName, Email, Phone, Location, ImageUrl)
VALUES
-- Job Seekers
(1, 'John', 'Doe', 'john.doe@example.com', '555-111-1234', 'San Francisco, CA', NULL),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '555-111-2345', 'Austin, TX', NULL),
(3, 'Mike', 'Johnson', 'mike.johnson@example.com', '555-111-3456', 'Boston, MA', NULL),
(4, 'Emily', 'Davis', 'emily.davis@example.com', '555-111-4567', 'New York, NY', NULL),
(5, 'Chris', 'Martin', 'chris.martin@example.com', '555-111-5678', 'Los Angeles, CA', NULL),
(6, 'Sarah', 'Taylor', 'sarah.taylor@example.com', '555-111-6789', 'San Francisco, CA', NULL),
(7, 'Tom', 'Brown', 'tom.brown@example.com', '555-111-7890', 'Austin, TX', NULL),
(8, 'Amy', 'Miller', 'amy.miller@example.com', '555-111-8901', 'Boston, MA', NULL),
(9, 'Steve', 'Robinson', 'steve.robinson@example.com', '555-111-3458', 'Los Angeles, CA', NULL),
-- Insert persons
(10, 'Laura', 'Wilson', 'laura.wilson@example.com', '555-111-9012', 'New York, NY', NULL),
(11, 'Sam', 'Moore', 'sam.moore@example.com', '555-111-0123', 'Los Angeles, CA', NULL),
(12, 'Ava', 'Harris', 'ava.harris@example.com', '555-111-1235', 'San Francisco, CA', NULL),
(13, 'David', 'Clark', 'david.clark@example.com', '555-111-2346', 'Austin, TX', NULL),
(14, 'Sara', 'Lewis', 'sara.lewis@example.com', '555-111-3457', 'Boston, MA', NULL),
(15, 'Ethan', 'Young', 'ethan.young@example.com', '555-111-4568', 'New York, NY', NULL),
-- Job Posters
(16, 'Nancy', 'Walker', 'nancy.walker@example.com', '555-111-5679', 'San Francisco, CA', NULL),
(17, 'Daniel', 'Hall', 'daniel.hall@example.com', '555-111-6780', 'Austin, TX', NULL),
(18, 'Sophia', 'Allen', 'sophia.allen@example.com', '555-111-7891', 'Boston, MA', NULL),
(19, 'Jack', 'Wright', 'jack.wright@example.com', '555-111-8902', 'New York, NY', NULL),
(20, 'Olivia', 'Adams', 'olivia.adams@example.com', '555-111-9013', 'Los Angeles, CA', NULL);

-- Insert job posters
INSERT INTO main.JobPoster (UserId, CompanyId, PersonId)
VALUES (16, 1, 16),
       (17, 2, 17),
       (18, 3, 18),
       (19, 4, 19),
       (20, 5, 20);

-- Insert job seekers
INSERT INTO main.JobSeeker (UserId, PersonId, School, Major, Degree, GraduationYear, Experience, Skills, Description)
VALUES (1, 1, 'Stanford University', 'Computer Science', 'Bachelor', 2022, '2 years', 'Python, Java, C++',
        'Enthusiastic programmer with a passion for innovation'),
       (2, 2, 'University of Texas', 'Mechanical Engineering', 'Master', 2021, '1 year', 'SolidWorks, AutoCAD, Matlab',
        'Detail-oriented engineer with strong problem-solving skills'),
       (3, 3, 'Harvard University', 'Medicine', 'Doctor', 2020, '3 years', 'Surgery, Patient Care, Diagnostics',
        'Compassionate and dedicated healthcare professional'),
       (4, 4, 'Columbia University', 'Finance', 'Bachelor', 2019, '4 years',
        'Financial Analysis, Excel, Risk Management', 'Results-driven finance professional with a proven track record'),
       (5, 5, 'UCLA', 'Graphic Design', 'Bachelor', 2018, '5 years', 'Adobe Creative Suite, UX/UI Design, Web Design',
        'Creative designer with a strong visual sense and attention to detail'),
       (6, 6, 'UC Berkeley', 'Computer Science', 'Master', 2022, '1 year', 'JavaScript, HTML, CSS',
        'Full stack developer with experience in web applications'),
       (7, 7, 'University of Texas', 'Civil Engineering', 'Bachelor', 2021, '2 years',
        'AutoCAD, Project Management, Structural Analysis',
        'Dedicated engineer with a focus on sustainable infrastructure'),
       (8, 8, 'MIT', 'Physics', 'PhD', 2020, '3 years', 'Data Analysis, Matlab, Research',
        'Analytical physicist with strong research capabilities'),
       (9, 9, 'Yale University', 'Marketing', 'Bachelor', 2019, '4 years', 'SEO, Social Media, Google Analytics',
        'Marketing professional with a focus on digital strategies'),
       (10, 10, 'Princeton University', 'Architecture', 'Master', 2018, '5 years', 'AutoCAD, Revit, SketchUp',
        'Innovative architect with experience in urban design'),
       (11, 11, 'University of Michigan', 'Economics', 'Bachelor', 2022, '1 year',
        'Econometrics, Stata, Policy Analysis', 'Economist with a passion for public policy'),
       (12, 12, 'Duke University', 'Environmental Science', 'Master', 2021, '2 years',
        'GIS, Remote Sensing, Field Research', 'Environmental scientist committed to conservation and sustainability'),
       (13, 13, 'University of Pennsylvania', 'Psychology', 'Doctor', 2020, '3 years',
        'Counseling, Research, Mental Health', 'Psychologist with expertise in mental health and wellbeing'),
       (14, 14, 'Cornell University', 'Hospitality Management', 'Bachelor', 2019, '4 years',
        'Event Planning, Customer Service, Hotel Operations',
        'Hospitality professional with a focus on exceptional service'),
       (15, 15, 'Northwestern University', 'Journalism', 'Bachelor', 2018, '5 years', 'Writing, Editing, Reporting',
        'Journalist with experience in investigative reporting and storytelling');

-- Update TypeMask for job seekers
UPDATE main.User
SET TypeMask = 8
WHERE Id BETWEEN 1 AND 15;

-- Update TypeMask for job posters
UPDATE main.User
SET TypeMask = 16
WHERE Id BETWEEN 16 AND 20;

INSERT INTO main.JobPost (Title, Description, Salary, Location, CompanyId, JobCategoriesMask, PosterId)
VALUES ('Software Engineer',
        'We are seeking a talented Software Engineer to join our team. The ideal candidate should have strong programming skills, experience with various programming languages, and a passion for technology. The Software Engineer will be responsible for developing and maintaining software applications, debugging and troubleshooting issues, and working closely with other team members. Excellent communication skills and the ability to work in a fast-paced, collaborative environment are essential. This is an exciting opportunity for someone looking to grow their career in software engineering.',
        90000,
        'San Francisco, CA',
        1,
        1,
        16),

       ('Mechanical Engineer',
        'Our company is looking for an experienced Mechanical Engineer to join our team. The successful candidate will be responsible for designing, developing, and testing mechanical systems and components. They will work closely with other engineers, project managers, and production staff to ensure projects are completed on time and within budget. Strong problem-solving skills, attention to detail, and the ability to work well under pressure are essential for this role. This is a fantastic opportunity for a Mechanical Engineer to make a significant impact in a growing company.',
        80000,
        'Austin, TX',
        2,
        2,
        17),

       ('Medical Doctor',
        'We are currently seeking a Medical Doctor to join our healthcare team. The ideal candidate will have a strong background in patient care, diagnostics, and treatment planning. The Medical Doctor will be responsible for providing primary care to patients, managing their medical needs, and coordinating with other healthcare professionals. Excellent communication skills, compassion, and a commitment to patient safety are essential for success in this role. This is a unique opportunity for a Medical Doctor to make a difference in the lives of our patients.',
        150000,
        'Boston, MA',
        3,
        3,
        18),

       ('Financial Analyst',
        'We are searching for a Financial Analyst to join our team. The successful candidate will be responsible for analyzing financial data, creating financial models, and providing recommendations to support business decisions. They will also work closely with the finance team to develop budgets and financial forecasts. Strong analytical skills, attention to detail, and the ability to work under tight deadlines are essential for this role. This is an excellent opportunity for a Financial Analyst to grow their career in a dynamic, fast-paced environment.',
        70000,
        'New York, NY',
        4,
        4,
        19),

       ('Graphic Designer',
        'We are looking for a creative Graphic Designer to join our design team. The ideal candidate should have a strong portfolio showcasing their design skills, experience with Adobe Creative Suite, and a keen eye for detail. The Graphic Designer will be responsible for creating visually stunning designs for print, web, and social media platforms. They will also collaborate with other team members to ensure projects are completed on time and meet client expectations. This is a fantastic opportunity for a Graphic Designer to showcase their talents and grow their career.',
        60000,
        'Los Angeles, CA',
        5,
        5,
        20),

       ('Data Scientist',
        'Our company is seeking a skilled Data Scientist to join our team. The successful candidate will be responsible for analyzing large datasets, developing predictive models, and providing actionable insights to support business decisions. They should have experience with machine learning algorithms, data visualization tools, and programming languages such as Python or R. Strong problem-solving skills, attention to detail, and the ability to work well under pressure are essential for this role. This is an excellent opportunity for a Data Scientist to make a significant impact in a growing company.',
        100000,
        'San Francisco, CA',
        1,
        6,
        16),

       ('Project Manager',
        'We are looking for an experienced Project Manager to join our team. The ideal candidate should have a background in managing projects from inception to completion, coordinating with cross-functional teams, and ensuring deadlines and budgets are met. The Project Manager will be responsible for planning, executing, and closing projects, as well as communicating project status to stakeholders. Strong leadership skills, excellent communication abilities, and a detail-oriented mindset are essential for success in this role. This is a great opportunity for a Project Manager to make a significant impact in a growing company.',
        85000,
        'Austin, TX',
        2,
        7,
        17),

       ('Digital Marketing Specialist',
        'Our company is seeking a Digital Marketing Specialist to join our marketing team. The successful candidate will be responsible for developing and implementing digital marketing strategies to drive online traffic, increase brand awareness, and generate leads. They should have experience with SEO, social media, email marketing, and content creation. Strong analytical skills, attention to detail, and the ability to work under tight deadlines are essential for this role. This is an excellent opportunity for a Digital Marketing Specialist to grow their career in a dynamic, fast-paced environment.',
        65000,
        'New York, NY',
        4,
        8,
        19);

       
