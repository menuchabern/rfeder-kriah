use master 
go
drop database if exists KriahDB
go
create database KriahDB
go
use KriahDB
go

drop table if exists dbo.Kriah
GO
create table dbo.KriahSessions(
	SessionID int identity primary key not null,
	FirstName varchar (15) not null constraint ck_kriah_sessions_first_name_cannot_be_blank check (FirstName <> ''),
	LastName varchar (20) not null constraint ck_kriah_sessions_last_name_cannot_be_blank check (LastName <> ''),
	SessionDate date constraint ck_session_date_must_be_after_sep_1_and_not_in_the_future check(SessionDate between '1/1/2024' and getdate()),
	SessionNumber tinyint not null constraint ck_kriah_session_number_must_be_greater_than_zero check (SessionNumber > 0),
	SessionTime tinyint not null constraint ck_kriah_session_time_must_be_greater_than_zero check(SessionTime > 0),
	SessionLocation varchar (25) not null constraint ck_kriah_sessions_location_cannot_be_blank check (SessionLocation <> ''),
	PaymentAmount as case when SessionLocation = 'Tutor home' then SessionTime * 1.5 else (SessionTime * 1.5) * 1.3 end ,
	PaymentPaid varchar (6) not null constraint ck_kriah_session_payment_paid_must_be_paid_or_unpaid check (PaymentPaid in ('paid', 'unpaid'))
	constraint u_kriah_session_session_date_must_be_unique_per_first_name_and_last_name unique(SessionDate, FirstName, LastName),
	constraint ck_kriah_session_students_session_time_must_be_consistant check ((LastName = LastName) and (SessionTime = SessionTime))
)
