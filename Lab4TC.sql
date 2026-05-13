-- Lab 4: Database Normalization and Implementation (3NF)
-- Tutoring Center System
-- Name: Eli Michel

DROP DATABASE IF EXISTS tutoring_center_db;
CREATE DATABASE tutoring_center_db;
USE tutoring_center_db;

-- =========================
-- Create Tables
-- =========================

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    StudentEmail VARCHAR(120) NOT NULL UNIQUE,
    Major VARCHAR(80) NOT NULL
);

CREATE TABLE Tutor (
    TutorID INT PRIMARY KEY,
    TutorName VARCHAR(100) NOT NULL,
    TutorEmail VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE Course (
    CourseID VARCHAR(10) PRIMARY KEY,
    CourseTitle VARCHAR(120) NOT NULL,
    Department VARCHAR(80) NOT NULL
);

CREATE TABLE Room (
    RoomID VARCHAR(10) PRIMARY KEY,
    RoomBuilding VARCHAR(100) NOT NULL,
    RoomCapacity INT NOT NULL CHECK (RoomCapacity > 0)
);

CREATE TABLE TutoringSession (
    SessionID INT PRIMARY KEY,
    SessionDate DATE NOT NULL,
    SessionTime TIME NOT NULL,
    StudentID INT NOT NULL,
    TutorID INT NOT NULL,
    CourseID VARCHAR(10) NOT NULL,
    RoomID VARCHAR(10) NOT NULL,
    SessionType VARCHAR(30) NOT NULL,
    HourlyRate DECIMAL(6,2) NOT NULL CHECK (HourlyRate >= 0),
    DurationMinutes INT NOT NULL CHECK (DurationMinutes > 0),
    CONSTRAINT fk_session_student
        FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    CONSTRAINT fk_session_tutor
        FOREIGN KEY (TutorID) REFERENCES Tutor(TutorID),
    CONSTRAINT fk_session_course
        FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    CONSTRAINT fk_session_room
        FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
);

-- =========================
-- Insert  Data
-- At least 5 records in each table
-- =========================

INSERT INTO Student (StudentID, StudentName, StudentEmail, Major) VALUES
(1001, 'Maria Lopez', 'maria.lopez@university.edu', 'Computer Science'),
(1002, 'James Carter', 'james.carter@university.edu', 'Biology'),
(1003, 'Aisha Khan', 'aisha.khan@university.edu', 'Business'),
(1004, 'Noah Williams', 'noah.williams@university.edu', 'Mathematics'),
(1005, 'Emily Nguyen', 'emily.nguyen@university.edu', 'Nursing');

INSERT INTO Tutor (TutorID, TutorName, TutorEmail) VALUES
(2001, 'Daniel Kim', 'daniel.kim@university.edu'),
(2002, 'Sofia Martinez', 'sofia.martinez@university.edu'),
(2003, 'Ethan Johnson', 'ethan.johnson@university.edu'),
(2004, 'Olivia Brown', 'olivia.brown@university.edu'),
(2005, 'Marcus Green', 'marcus.green@university.edu');

INSERT INTO Course (CourseID, CourseTitle, Department) VALUES
('CS101', 'Introduction to Programming', 'Computer Science'),
('MATH151', 'Calculus I', 'Mathematics'),
('BIO110', 'General Biology', 'Biology'),
('BUS210', 'Principles of Management', 'Business'),
('CHEM121', 'General Chemistry', 'Chemistry');

INSERT INTO Room (RoomID, RoomBuilding, RoomCapacity) VALUES
('R101', 'Science Hall', 24),
('R102', 'Library Learning Center', 18),
('R201', 'Technology Building', 30),
('R202', 'Technology Building', 22),
('R301', 'Academic Success Center', 16);

INSERT INTO TutoringSession
(SessionID, SessionDate, SessionTime, StudentID, TutorID, CourseID, RoomID, SessionType, HourlyRate, DurationMinutes) VALUES
(3001, '2026-05-04', '10:00:00', 1001, 2001, 'CS101', 'R201', 'Individual', 25.00, 60),
(3002, '2026-05-04', '11:30:00', 1002, 2003, 'BIO110', 'R101', 'Group', 22.50, 90),
(3003, '2026-05-05', '14:00:00', 1003, 2002, 'BUS210', 'R102', 'Individual', 24.00, 45),
(3004, '2026-05-06', '09:00:00', 1004, 2004, 'MATH151', 'R301', 'Individual', 26.00, 60),
(3005, '2026-05-06', '13:30:00', 1005, 2005, 'CHEM121', 'R101', 'Group', 23.00, 75),
(3006, '2026-05-07', '15:00:00', 1001, 2004, 'MATH151', 'R202', 'Individual', 26.00, 60),
(3007, '2026-05-08', '12:00:00', 1002, 2001, 'CS101', 'R201', 'Group', 25.00, 90);

-- =========================
-- Required Queries
-- =========================

-- 1. Display all tutoring sessions with student name, tutor name, course title, and room ID.
SELECT
    ts.SessionID,
    ts.SessionDate,
    ts.SessionTime,
    s.StudentName,
    t.TutorName,
    c.CourseTitle,
    ts.RoomID,
    ts.SessionType,
    ts.DurationMinutes
FROM TutoringSession ts
JOIN Student s ON ts.StudentID = s.StudentID
JOIN Tutor t ON ts.TutorID = t.TutorID
JOIN Course c ON ts.CourseID = c.CourseID
ORDER BY ts.SessionDate, ts.SessionTime;

-- 2. List all sessions for a specific student.
-- Example student: Maria Lopez, StudentID 1001
SELECT
    ts.SessionID,
    ts.SessionDate,
    ts.SessionTime,
    s.StudentName,
    c.CourseTitle,
    t.TutorName,
    ts.RoomID
FROM TutoringSession ts
JOIN Student s ON ts.StudentID = s.StudentID
JOIN Course c ON ts.CourseID = c.CourseID
JOIN Tutor t ON ts.TutorID = t.TutorID
WHERE ts.StudentID = 1001
ORDER BY ts.SessionDate, ts.SessionTime;

-- 3. List all sessions conducted by a specific tutor.
-- Example tutor: Daniel Kim, TutorID 2001
SELECT
    ts.SessionID,
    ts.SessionDate,
    ts.SessionTime,
    t.TutorName,
    s.StudentName,
    c.CourseTitle,
    ts.RoomID
FROM TutoringSession ts
JOIN Tutor t ON ts.TutorID = t.TutorID
JOIN Student s ON ts.StudentID = s.StudentID
JOIN Course c ON ts.CourseID = c.CourseID
WHERE ts.TutorID = 2001
ORDER BY ts.SessionDate, ts.SessionTime;

-- 4. Count the number of sessions per course.
SELECT
    c.CourseID,
    c.CourseTitle,
    COUNT(ts.SessionID) AS NumberOfSessions
FROM Course c
LEFT JOIN TutoringSession ts ON c.CourseID = ts.CourseID
GROUP BY c.CourseID, c.CourseTitle
ORDER BY NumberOfSessions DESC, c.CourseID;

