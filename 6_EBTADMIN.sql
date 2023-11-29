exec updateEBTApplicationStatus(1,'APPROVED');
exec updateEBTApplicationStatus(2,'REJECTED');
exec updateEBTApplicationStatus(3,'APPROVED');
exec updateEBTApplicationStatus(4,'APPROVED');
exec updateEBTApplicationStatus(5,'REJECTED');

select * from ebtapplication;
select * from ebtcard;
select * from ebtaccount;