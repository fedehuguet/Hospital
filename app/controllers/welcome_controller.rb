class WelcomeController < ApplicationController
  def index
  	sql = "SELECT P.fname, P.lname, visitdate, D.fname, D.lname
FROM Patient P 
JOIN EHR on P.ehrid = EHR.ehrid
JOIN DoctorVisit dv on EHR.ehrid = dv.ehrid
JOIN Doctor D on dv.doctorid = D.doctorid;
"
	@response = ActiveRecord::Base.connection.execute(sql)
  end

  def expediente
  	  	sql1 = "select p.fname as Patientfname, p.lname Patientlname, bloodtype, birthdate, sex
from patient p JOIN EHR e ON p.ehrid = e.ehrid
where p.patientid=2;
"
	sql2 = "Select d.fname as Doctorfname, d.lname Doctorlname, surgeryType, surgerydate
From Patient p JOIN EHR e ON p.ehrid = e.ehrid
	JOIN DoctorVisit dv ON e.ehrid = dv.ehrid
	JOIN Doctor d ON dv.doctorid = d.doctorid
	JOIN Surgeries s ON p.patientid = s.pid
	WHERE patientid = 2;
"
	sql3 = "Select allergyname
from allergies
where ehrid = 2;
	"
	sqllt1 = "select indicator, ltrvalue as ResultValue, ltr.comments, lticmin as Minimum, lticmax as Maximum
FROM EHR e JOIN LabTest lt ON e.ehrid = lt.ehrid
	JOIN LabTestResults ltr ON lt.labtestid = ltr.labtestid
	JOIN LabTestCatalog ltc ON lt.labtestcatalogid = ltc.labtestcatalogid
	JOIN LabTestIndicatorCatalog  ltic ON ltr.labtestindicatorcatalogid = ltic.labtestindicatorcatalogid
	WHERE e.ehrid = 2 AND name='Biometria Hematica';
	"
	sqllt2 = "select indicator, ltrvalue as ResultValue, ltr.comments, lticmin as Minimum, lticmax as Maximum
FROM EHR e JOIN LabTest lt ON e.ehrid = lt.ehrid
	JOIN LabTestResults ltr ON lt.labtestid = ltr.labtestid
	JOIN LabTestCatalog ltc ON lt.labtestcatalogid = ltc.labtestcatalogid
	JOIN LabTestIndicatorCatalog  ltic ON ltr.labtestindicatorcatalogid = ltic.labtestindicatorcatalogid
	WHERE e.ehrid = 2 AND name='Perfil de Lipidos';
	"
	sql4 = "select prescriptiondate, genericname, startDate, endDate, instructions
From DoctorVisit dv 
	JOIN Prescription pr ON dv.visitid = pr.doctorvisitid
	JOIN PrescriptionDetails pd ON pr.prescriptionid = pd.pid
	JOIN DrugCatalog dc ON pd.dcid = dc.id
	WHERE dv.ehrid = 2;
	"
		sqlb = "Select name, d.fname, d.lname, ltdate 
		FROM EHR e JOIN LabTest lt ON e.ehrid = lt.ehrid
		JOIN LabTestCatalog ltc ON lt.labtestcatalogid = ltc.labtestcatalogid
		JOIN DoctorVisit dv ON e.ehrid = dv.ehrid
		JOIN Doctor d ON dv.doctorid = d.doctorid
		WHERE e.ehrid=2 AND name ='Biometria Hematica'
		Limit 1;
"
		sqlp = "Select name, d.fname, d.lname, ltdate 
		FROM EHR e JOIN LabTest lt ON e.ehrid = lt.ehrid
		JOIN LabTestCatalog ltc ON lt.labtestcatalogid = ltc.labtestcatalogid
		JOIN DoctorVisit dv ON e.ehrid = dv.ehrid
		JOIN Doctor d ON dv.doctorid = d.doctorid
		WHERE e.ehrid=2 AND name ='Perfil de Lipidos'
		Limit 1;
"
	@response1 = ActiveRecord::Base.connection.execute(sql1)
	@response2 = ActiveRecord::Base.connection.execute(sql2)
	@response3 = ActiveRecord::Base.connection.execute(sql3)
	@responselt1 = ActiveRecord::Base.connection.execute(sqllt1)
	@responselt2 = ActiveRecord::Base.connection.execute(sqllt2)
	@response4 = ActiveRecord::Base.connection.execute(sql4)
	@resb = ActiveRecord::Base.connection.execute(sqlb)
	@resp = ActiveRecord::Base.connection.execute(sqlp)
  end
  def abnormal
  	sql = "SELECT  fname, lname, ltdate as Date, indicator, lticmin, lticmax, ltrvalue, comments
FROM Patient P Join EHR E ON P.ehrid = E.ehrid
JOIN LabTest LT ON E.ehrid = LT.ehrid
JOIN LabTestResults LR ON LT.labtestid = LR.resultid
JOIN LabTestIndicatorCatalog LC ON LR.labtestindicatorcatalogid = LC.labtestindicatorcatalogid
WHERE isanormal = 1
Order By ltdate DESC;
"
	@response = ActiveRecord::Base.connection.execute(sql)
  end
    def prescriptions
  	sql1 = "select p.fname as Patientfname, p.lname as Patientlname, d.fname as Doctorfname, d.lname as Doctorlname, prescriptiondate
from patient p join EHR e on e.ehrid=p.ehrid
join doctorvisit dv on e.ehrid=dv.ehrid
JOIN doctor d on d.doctorid =dv.doctorid
join prescription pre on dv.visitid=pre.doctorvisitid
where patientid=1 and pre.prescriptionid=1;
"
sql2 = "select genericname, dc.comments,startdate, enddate
from patient p join EHR e on e.ehrid=p.ehrid
join doctorvisit dv on e.ehrid=dv.ehrid
join prescription pre on dv.visitid=pre.doctorvisitid
join prescriptiondetails pd on pid=pre.prescriptionid
join drugcatalog dc on dc.id=pd.dcid
where patientid=1;
"
	@response1 = ActiveRecord::Base.connection.execute(sql1)
	@response2 = ActiveRecord::Base.connection.execute(sql2)
  end
  def labtest
  	sqlinfo = "Select p.fname as Patientfname, p.lname Patientlname, d.fname as Doctorfname, d.lname as Doctorlname, ltc.name as LabTestNAme
FROM Patient p
JOIN EHR e ON e.ehrid = p.ehrid
JOIN LabTest lt ON lt.ehrid = e.ehrid
JOIN LabTestCatalog ltc ON ltc.labtestcatalogid = lt.labtestcatalogid
JOIN DoctorVisit dv ON e.ehrid = dv.ehrid
JOIN Doctor d ON d.doctorid = dv.doctorid
Where lt.labtestid = 1;
"
  	sqllabtest1pat1 = 
  	"SELECT indicator, lticmin, lticmax, ltrvalue, ltr.comments
From LabTestIndicatorCatalog ltic
JOIN LabTestResults ltr ON ltic.labtestindicatorcatalogid = ltr.labtestindicatorcatalogid
WHERE ltic.labtestcatalogid=1 AND ltr.labtestid IN (
	SELECT labtestid
    FROM LabTest
    Where ehrid = 1
);
"
  	sqlinfo2 = "Select p.fname as Patientfname, p.lname Patientlname, d.fname as Doctorfname, d.lname as Doctorlname, ltc.name as LabTestNAme
FROM Patient p
JOIN EHR e ON e.ehrid = p.ehrid
JOIN LabTest lt ON lt.ehrid = e.ehrid
JOIN LabTestCatalog ltc ON ltc.labtestcatalogid = lt.labtestcatalogid
JOIN DoctorVisit dv ON e.ehrid = dv.ehrid
JOIN Doctor d ON d.doctorid = dv.doctorid
Where lt.labtestid = 16;
"
  	sqllabtest2pat2 = 
  	"SELECT indicator, lticmin, lticmax, ltrvalue, ltr.comments
From LabTestIndicatorCatalog ltic
JOIN LabTestResults ltr ON ltic.labtestindicatorcatalogid = ltr.labtestindicatorcatalogid
WHERE ltic.labtestcatalogid=2 AND ltr.labtestid IN (
	SELECT labtestid
    FROM LabTest
    Where ehrid = 2
);
"
	@response1 = ActiveRecord::Base.connection.execute(sqlinfo)
	@response2 = ActiveRecord::Base.connection.execute(sqllabtest1pat1)
	@response3 = ActiveRecord::Base.connection.execute(sqlinfo2)
	@response4 = ActiveRecord::Base.connection.execute(sqllabtest2pat2)
  end
end
