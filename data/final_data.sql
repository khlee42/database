/* script name: CREATEBIGPV_EDM_1E.SQL                   */
/* purpose:     Builds Oracle tables for Big PVFC DB EDM */
/* date:        10 June 2013                             */
/* updated:                                              */
/*                                                       */
/* comment:  These tables have the same names as the     */
/*           Book PVFC database, so if you run these     */
/*           script files after you have created the     */
/*           Book database files, you will wipe out      */
/*           the data in the earlier database            */
/*                                                       */
/* comment:  The Photo column in the PRODUCT table       */
/*           is not included in the Oracle version of    */
/*           this database                               */
/*                                                       */
/* comment:  Table and column names are defined in       */
/*           U/L case without embedded underscores.      */
/*           They will be displayed by Oracle, however,  */
/*           in ALL CAPS use an alias to override       */
/*           the ALL CAPS display.                       */
/*                                                       */
/*                                                       */

/*     set up session settings                           */

SET LINESIZE 120
SET PAGESIZE 80

/* Drop all tables before creating tables                */
DROP TABLE Supplies_T 		        CASCADE CONSTRAINTS ;
DROP TABLE Uses_T 		            CASCADE CONSTRAINTS ;
DROP TABLE RawMaterial_T 	        CASCADE CONSTRAINTS ;
DROP TABLE Vendor_T 		          CASCADE CONSTRAINTS ;
DROP TABLE Shipped_T              CASCADE CONSTRAINTS ;
DROP TABLE PaymentType_T          CASCADE CONSTRAINTS ;
DROP TABLE Payment_T              CASCADE CONSTRAINTS ;
DROP TABLE OrderLine_T 	          CASCADE CONSTRAINTS ;
DROP TABLE Order_T 		            CASCADE CONSTRAINTS ;
DROP TABLE CustomerShipAddress_T  CASCADE CONSTRAINTS ;
DROP TABLE ProducedIn_T           CASCADE CONSTRAINTS ;
DROP TABLE Product_T 		          CASCADE CONSTRAINTS ;
DROP TABLE ProductLine_T 	        CASCADE CONSTRAINTS ;
DROP TABLE WorksIn_T 		          CASCADE CONSTRAINTS ;
DROP TABLE WorkCenter_T 	        CASCADE CONSTRAINTS ;
DROP TABLE EmployeeSkills_T 	    CASCADE CONSTRAINTS ;
DROP TABLE Employee_T 		        CASCADE CONSTRAINTS ;
DROP TABLE Skill_T 		            CASCADE CONSTRAINTS ;
DROP TABLE Salesperson_T 	        CASCADE CONSTRAINTS ;
DROP TABLE DoesBusinessIn_T 	    CASCADE CONSTRAINTS ;
DROP TABLE Territory_T 		        CASCADE CONSTRAINTS ;
DROP TABLE Customer_T 		        CASCADE CONSTRAINTS ;



/* Create all PVFC Big Database Tables (23)              */

CREATE TABLE Customer_T
	(CustomerID         NUMBER(4)          NOT NULL,
	 CustomerName       VARCHAR(25)    ,
	 CustomerAddress    VARCHAR(30)    ,
         CustomerCity       VARCHAR(20)    ,              
         CustomerState      CHAR(2)        ,
         CustomerPostalCode VARCHAR(10)    ,
CONSTRAINT Customer_PK PRIMARY KEY (CustomerID));



CREATE TABLE Territory_T
	(TerritoryID        NUMBER(4)         NOT NULL,
         TerritoryName      VARCHAR(50)    ,
CONSTRAINT Territory_PK PRIMARY KEY (TerritoryID));



CREATE TABLE DoesBusinessIn_T
	(CustomerID         NUMBER(4)           NOT NULL,
         TerritoryID        NUMBER(4)           NOT NULL,
CONSTRAINT DoesBusinessIn_PK PRIMARY KEY (CustomerID, TerritoryID),
CONSTRAINT DoesBusinessIn_FK1 FOREIGN KEY (CustomerID) 
	REFERENCES Customer_T(CustomerID),
CONSTRAINT DoesBusinessIn_FK2 FOREIGN KEY (TerritoryID) 
	REFERENCES Territory_T(TerritoryID));


CREATE TABLE Salesperson_T
	(SalespersonID        NUMBER(4)          NOT NULL,              
   SalespersonName       VARCHAR(25)    , /* Fixed */
   SalespersonTelephone VARCHAR(50)    ,
   SalespersonFax       VARCHAR(50)    ,
	 SalespersonAddress   VARCHAR(30)    ,
	 SalespersonCity      VARCHAR(20)    ,
	 SalespersonState     CHAR(2)        ,
	 SalespersonZip       VARCHAR(20)    ,
         SalesTerritoryID     NUMBER(4)      ,
CONSTRAINT Salesperson_PK PRIMARY KEY (SalespersonID),
CONSTRAINT Salesperson_FK1 FOREIGN KEY (SalesTerritoryID) /*Fixed*/
	REFERENCES Territory_T(TerritoryID));


CREATE TABLE Skill_T
	(SkillID            VARCHAR(12)    NOT NULL,
	 SkillDescription   VARCHAR(30)    ,              
CONSTRAINT Skill_PK PRIMARY KEY (SkillID));



CREATE TABLE Employee_T
	(EmployeeID         VARCHAR(10)    NOT NULL,
         EmployeeName       VARCHAR(25)    ,
         EmployeeAddress    VARCHAR(30)    ,
         EmployeeCity       VARCHAR(20)    ,
	 EmployeeState      CHAR(2)        ,
         EmployeeZip        VARCHAR(10)    ,
	 EmployeeBirthDate  DATE           ,
         EmployeeDateHired  DATE           ,
	 EmployeeSupervisor VARCHAR(10)    ,
CONSTRAINT Employee_PK PRIMARY KEY (EmployeeID));



CREATE TABLE EmployeeSkills_T
	(EmployeeID         VARCHAR(10)    NOT NULL,
         SkillID            VARCHAR(12)    NOT NULL,
	 QualifyDate 	    DATE	           ,
CONSTRAINT EmployeeSkills_PK PRIMARY KEY (EmployeeID, SkillID),
CONSTRAINT EmployeeSkills_FK1 FOREIGN KEY (EmployeeID) 
	REFERENCES Employee_T(EmployeeID),
CONSTRAINT EmployeeSkills_FK2 FOREIGN KEY (SkillID) 
	REFERENCES Skill_T(SkillID));


CREATE TABLE WorkCenter_T
	(WorkCenterID       VARCHAR(12)    NOT NULL,
	 WorkCenterLocation  VARCHAR(30)           ,
CONSTRAINT WorkCenter_PK PRIMARY KEY (WorkCenterID));


CREATE TABLE WorksIn_T
	(EmployeeID          VARCHAR(10)    NOT NULL,
         WorkCenterID        VARCHAR(12)    NOT NULL,
CONSTRAINT WorksIn_PK PRIMARY KEY (EmployeeID, WorkCenterID),
CONSTRAINT WorksIn_FK1 FOREIGN KEY (EmployeeID) 
	REFERENCES Employee_T(EmployeeID),
CONSTRAINT WorksIn_FK2 FOREIGN KEY (WorkCenterID) 
	REFERENCES WorkCenter_T(WorkCenterID));


CREATE TABLE ProductLine_T
	(ProductLineID     NUMBER(4)         NOT NULL,
	ProductLineName    VARCHAR(50)               ,
CONSTRAINT ProductLine_PK PRIMARY KEY (ProductLineID));


CREATE TABLE Product_T
	(ProductID            NUMBER(4)         NOT NULL,
         ProductLineID        NUMBER(4)      ,
         ProductDescription   VARCHAR(50)    ,
         ProductFinish        VARCHAR(20)    ,
         ProductStandardPrice NUMBER(6,2)    ,
	 ProductOnHand	      NUMBER(6)      ,
CONSTRAINT Product_PK PRIMARY KEY (ProductID),
CONSTRAINT Product_FK1 FOREIGN KEY (ProductLineID) 
	REFERENCES ProductLine_T(ProductLineID));


CREATE TABLE ProducedIn_T
	(ProductID	  NUMBER(4)	 NOT NULL,
         WorkCenterID     VARCHAR(12)    NOT NULL,
CONSTRAINT ProducedInPK PRIMARY KEY (ProductID, WorkCenterID),
CONSTRAINT ProducedInFK1 FOREIGN KEY (ProductID) 
	REFERENCES Product_T(ProductID),
CONSTRAINT ProducedInFK2 FOREIGN KEY (WorkCenterID) 
	REFERENCES WorkCenter_T(WorkCenterID));

CREATE TABLE CustomerShipAddress_T
	(ShipAddressID	NUMBER(4)	NOT NULL,
	 CustomerID	NUMBER(4)	NOT NULL,
	 TerritoryID	NUMBER(4)	NOT NULL,
	 ShipAddress	VARCHAR(30)	,
	 ShipCity	VARCHAR(20)	,
	 ShipState	CHAR(2)     	,
	 ShipZip	VARCHAR(10)	,
	 ShipDirections	VARCHAR(100)	,
CONSTRAINT CSA_PK PRIMARY KEY (ShipAddressID),
CONSTRAINT CSA_FK1 FOREIGN KEY (CustomerID)
	REFERENCES Customer_T(CustomerID),
CONSTRAINT CSA_FK2 FOREIGN KEY (TerritoryID)
	REFERENCES Territory_T(TerritoryID));


CREATE TABLE Order_T
	(OrderID            NUMBER(5)        NOT NULL,
	 CustomerID         NUMBER(4)   ,
         OrderDate          DATE        ,
	 FulfillmentDate    DATE	,
	 SalespersonID	    NUMBER(4)	,
	 ShipAdrsID	    NUMBER(4)	,
CONSTRAINT Order_PK PRIMARY KEY (OrderID),
CONSTRAINT Order_FK1 FOREIGN KEY (CustomerID) 
	REFERENCES Customer_T(CustomerID),
CONSTRAINT Order_FK2 FOREIGN KEY (SalespersonID)
	REFERENCES Salesperson_T(SalespersonID),
CONSTRAINT Order_FK3 FOREIGN KEY (ShipAdrsID)
	REFERENCES CustomerShipAddress_T(ShipAddressID));


CREATE TABLE OrderLine_T
	(OrderLineID	    NUMBER(4)	     NOT NULL,
	 OrderID            NUMBER(5)        NOT NULL,
         ProductID          NUMBER(4)        NOT NULL,
         OrderedQuantity    NUMBER(10)         ,
CONSTRAINT OrderLine_PK PRIMARY KEY (OrderLineID),
CONSTRAINT OrderLine_FK1 FOREIGN KEY (OrderID) 
	REFERENCES Order_T(OrderID),
CONSTRAINT OrderLine_FK2 FOREIGN KEY (ProductID) 
	REFERENCES Product_T(ProductID));

CREATE TABLE PaymentType_T
  (PaymentTypeID  VARCHAR(50)    NOT NULL,
  TypeDescription VARCHAR(50)   NOT NULL,
  CONSTRAINT PaymentType_PK  PRIMARY KEY (PaymentTypeID));
  
CREATE TABLE Payment_T
  (PaymentID      NUMBER(5)    NOT NULL,
   OrderID        NUMBER(5)    NOT NULL,
   PaymentTypeID  VARCHAR(50)  NOT NULL,
   PaymentDate    DATE                 ,
   PaymentAmount  NUMBER(6,2)          ,
   PaymentComment VARCHAR(255)         , 
  CONSTRAINT  Payment_PK  PRIMARY KEY (PaymentID),
  CONSTRAINT  Payment_FK1 FOREIGN KEY (OrderID)
    REFERENCES Order_T(OrderID),
  CONSTRAINT  Payment_FK2 FOREIGN KEY (PaymentTypeID)
    REFERENCES PaymentType_T(PaymentTypeID));
    
CREATE TABLE Shipped_T
  (OrderLineId  NUMBER(4) NOT NULL,
   ShippedQuantity     NUMBER(10) NOT NULL,
   ShippedDate         DATE,
  CONSTRAINT Shipped_PK PRIMARY KEY (OrderLineId),
  CONSTRAINT Shipped_FK1  FOREIGN KEY (OrderLineId)
    REFERENCES OrderLine_T(OrderLineID));


CREATE TABLE Vendor_T
	(VendorID           NUMBER(4)         NOT NULL,
         VendorName         VARCHAR(25)    ,
         VendorAddress      VARCHAR(30)    ,
         VendorCity         VARCHAR(20)    ,
         VendorState        CHAR(2)        ,
	 VendorZipcode      VARCHAR(50)    ,
	 VendorPhone        VARCHAR(12)    ,
	 VendorFax          VARCHAR(12)    ,              
	 VendorContact      VARCHAR(50)    ,
         VendorTaxIdNumber  VARCHAR(50)    ,
CONSTRAINT Vendor_PK PRIMARY KEY (VendorID));




CREATE TABLE RawMaterial_T
	(MaterialID             VARCHAR(12)    NOT NULL,
         MaterialName           VARCHAR(30) ,
	 Thickness		VARCHAR(50) ,
	 Width			VARCHAR(50) ,
	 MatSize			VARCHAR(50) ,  /*Fixed*/
	 Material		VARCHAR(15) ,
         MaterialStandardPrice  NUMBER(6,2) ,
         UnitOfMeasure          VARCHAR(15) ,
	 MaterialType		VARCHAR(50),
CONSTRAINT RawMaterial_PK PRIMARY KEY (MaterialID)); /*Fixed*/


CREATE TABLE Uses_T
        (MaterialID         VARCHAR(12)    NOT NULL,
         ProductID          NUMBER(4)      NOT NULL,
         QuantityRequired   NUMBER(5)              ,
CONSTRAINT Uses_PK PRIMARY KEY (ProductID, MaterialID),  /*Fixed*/
CONSTRAINT Uses_FK1 FOREIGN KEY (ProductID) 
	REFERENCES Product_T(ProductID),
CONSTRAINT Uses_FK2 FOREIGN KEY (MaterialID) 
	REFERENCES RawMaterial_T(MaterialID));


CREATE TABLE Supplies_T
	(VendorID           NUMBER(4)         NOT NULL,
         MaterialID         VARCHAR(12)       NOT NULL,
         SupplyUnitPrice    NUMBER(6,2)   ,              
CONSTRAINT Supplies_PK PRIMARY KEY (VendorID, MaterialID),
CONSTRAINT Supplies_FK1 FOREIGN KEY (MaterialID) 
	REFERENCES RawMaterial_T(MaterialID),
CONSTRAINT Supplies_FK2 FOREIGN KEY (VendorID) 
	REFERENCES Vendor_T(VendorID));


/* Run Oracle specific command to display table structure in DB    */
/*
describe Supplies_T;
describe Uses_T;
describe RawMaterial_T;
describe Vendor_T;
describe PaymentType_T;
describe Payment_T;
describe Shipped_T;
describe OrderLine_T;
describe Order_T;
describe CustomerShipAddress_T;
describe ProducedIn_T;
describe Product_T;
describe ProductLine_T;
describe WorksIn_T;
describe WordkCenter_T;
describe EmployeeSkills_T;
describe Employee_T;
describe Skill_T;
describe Salesperson_T;
describe DoesBusinessIn_T;
describe Territory_T;
describe Customer_T;
*/
/* show constraints for each table */


/* script name: LOAD1BIGPV_EDM_1E.SQL                         */
/* purpose:     Loads Oracle tables for Big PVFC DB EDM   */
/*             (NOT Raw Materials, Supplies, Uses tbls)  */
/* date:        10 June 2013                             */
/* updated:                                              */
/*                                                       */

/* make sure tables are empty before adding records      */

delete from Vendor_T;
delete from Shipped_T;
delete from Payment_T;
delete from PaymentType_T;
delete from OrderLine_T;
delete from Order_T;
delete from CustomerShipAddress_T;
delete from ProducedIn_T;
delete from Product_T;
delete from ProductLine_T;
delete from WorksIn_T;
delete from WorkCenter_T;
delete from EmployeeSkills_T;
delete from Skill_T;
delete from Employee_T;
delete from Salesperson_T;
delete from DoesBusinessIn_T;
delete from Territory_T;
delete from Customer_T;


/* load all tables but Raw Materials and Supplies and Uses        */

--REM INSERTING into Customer_T
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (1,'Contemporary Casuals','1355 S Hines Blvd','Gainesville','FL','32601-2871');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (2,'Value Furnitures','15145 S.W. 17th St.','Plano','TX','75094-7743');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (3,'Home Furnishings','1900 Allard Ave','Albany','NY','12209-1125');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (4,'Eastern Furniture','1925 Beltline Rd.','Carteret','NJ','07008-3188');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (5,'Impressions','5585 Westcott Ct.','Sacramento','CA','94206-4056');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (6,'Furniture Gallery','325 Flatiron Dr.','Boulder','CO','80514-4432');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (7,'New Furniture','Palace Ave','Farmington','NM',null);
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (8,'Dunkins Furniture','7700 Main St','Syracuse','NY','31590');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (9,'A Carpet','434 Abe Dr','Rome','NY','13440');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (12,'Flanigan Furniture','Snow Flake Rd','Ft Walton Beach','FL','32548');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (13,'Ikards','1011 S. Main St','Las Cruces','NM','88001');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (14,'Wild Bills','Four Horse Rd','Oak Brook','Il','60522');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (15,'Janet''s Collection','Janet Lane','Virginia Beach','VA','10012');
Insert into Customer_T (CustomerID,CustomerName,CustomerAddress,CustomerCity,CustomerState,CustomerPostalCode) values (16,'ABC Furniture Co.','152 Geramino Drive','Rome','NY','13440');


INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (1, 'SouthEast');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (2, 'SouthWest');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (3, 'NorthEast');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (4, 'NorthWest');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (5, 'Central');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (6, 'Alaska');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (12, 'Hawaii');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (13, 'Colorado');
INSERT INTO Territory_T  (TerritoryID, TerritoryName)
	VALUES  (15, 'Arizona');


INSERT INTO DoesBusinessIn_T  (CustomerID, TerritoryID)
	VALUES  (1, 1);
INSERT INTO DoesBusinessIn_T  (CustomerID, TerritoryID)
	VALUES  (2, 2);
INSERT INTO DoesBusinessIn_T  (CustomerID, TerritoryID)
	VALUES  (3, 3);
INSERT INTO DoesBusinessIn_T  (CustomerID, TerritoryID)
	VALUES  (4, 4);
INSERT INTO DoesBusinessIn_T  (CustomerID, TerritoryID)
	VALUES  (5, 5);
INSERT INTO DoesBusinessIn_T  (CustomerID, TerritoryID)
	VALUES  (6, 6);
INSERT INTO DoesBusinessIn_T  (CustomerID, TerritoryID)
	VALUES  (7, 1);

--REM INSERTING into Salesperson_T
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (1,'Doug Henny','8134445555',null,2,null,null,null,null);
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (2,'Robert Lewis','8139264006',null,13,'124 Deerfield','Lutz','FL','33549');
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (3,'William Strong','3153821212',null,3,'787 Syracuse Lane','Syracuse','NY','33240');
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (4,'Julie Dawson','4355346677',null,4,null,null,null,null);
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (5,'Jacob Winslow','2238973498',null,5,null,null,null,null);
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (6,'Pepe Lepue',null,null,13,null,'Platsburg','NY',null);
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (8,'Fred Flinstone',null,null,2,'1 Rock Lane','Bedrock','Ca','99999');
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (9,'Mary James','3035555454',null,4,'9 Red Line','Denver','CO','55555');
Insert into Salesperson_T (SalespersonID,SalespersonName,SalespersonTelephone,SalespersonFax,SalesTerritoryID,SalespersonAddress,SalespersonCity,SalespersonState,SalespersonZip) 
values (10,'Mary Smithson','4075555555',null,15,'4585 Maple Dr','Orlando','FL','32826');



INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('BS12', '12in Band Saw');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('QC1', 'Quality Control');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('RT1', 'Router');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('SO1', 'Sander-Orbital');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('SB1', 'Sander-Belt');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('TS10', '10in Table Saw');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('TS12', '12in Table Saw');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('UC1', 'Upholstery Cutter');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('US1', 'Upholstery Sewer');
INSERT INTO Skill_T  (SkillID, SkillDescription)
VALUES  ('UT1', 'Upholstery Tacker');


--REM INSERTING into Employee_T
Insert into Employee_T (EmployeeID,EmployeeName,EmployeeAddress,EmployeeCity,EmployeeState,EmployeeZip,EmployeeDateHired,EmployeeBirthDate,EmployeeSupervisor) values ('123-44-345','Phil Morris','2134 Hilltop Rd','Knoxville','TN',null,to_timestamp('12-JUN-99','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('05-JAN-57','DD-MON-RR HH.MI.SSXFF AM'),'454-56-768');
Insert into Employee_T (EmployeeID,EmployeeName,EmployeeAddress,EmployeeCity,EmployeeState,EmployeeZip,EmployeeDateHired,EmployeeBirthDate,EmployeeSupervisor) values ('332445667','Lawrence Haley','5970 Spring Crest Rd','Nashville','TN','54545',to_timestamp('05-JAN-99','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('15-AUG-63','DD-MON-RR HH.MI.SSXFF AM'),'454-56-768');
Insert into Employee_T (EmployeeID,EmployeeName,EmployeeAddress,EmployeeCity,EmployeeState,EmployeeZip,EmployeeDateHired,EmployeeBirthDate,EmployeeSupervisor) values ('454-56-768','Robert Lewis','17834 Deerfield Ln','Knoxville','TN','55555',to_timestamp('01-JAN-98','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('25-AUG-64','DD-MON-RR HH.MI.SSXFF AM'),'123-44-345');
Insert into Employee_T (EmployeeID,EmployeeName,EmployeeAddress,EmployeeCity,EmployeeState,EmployeeZip,EmployeeDateHired,EmployeeBirthDate,EmployeeSupervisor) values ('555955585','Mary Smith','75 Jane Lane','Clearwater','FL','33879',to_timestamp('15-AUG-00','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('06-MAY-69','DD-MON-RR HH.MI.SSXFF AM'),'332445667');
Insert into Employee_T (EmployeeID,EmployeeName,EmployeeAddress,EmployeeCity,EmployeeState,EmployeeZip,EmployeeDateHired,EmployeeBirthDate,EmployeeSupervisor) values ('555966586','Laura Ellenburg','5342 Picklied Trout Lane','Nashville','TN','38010',to_timestamp('22-FEB-00','DD-MON-RR HH.MI.SSXFF AM'),null,'454-56-768');



INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('123-44-345', 'BS12','');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('123-44-345', 'RT1', '');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('123-44-345', 'QC1', '01-JAN-01');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('123-44-345', 'TS10', '24-FEB-01');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('332445667', 'BS12','20-JAN-99');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('332445667', 'TS10','20-JAN-99');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('454-56-768', 'BS12', '25-FEB-01');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('454-56-768', 'RT1', '10-MAR-01');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('454-56-768', 'TS10', '10-MAR-01');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('Laura', 'UC1', '22-FEB-00');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('Laura', 'US1', '22-FEB-00');
INSERT INTO EmployeeSkills_T  (EmployeeID, SkillID, QualifyDate)
VALUES  ('Laura', 'UT1', '22-FEB-00');



INSERT INTO WorkCenter_T  (WorkCenterID, WorkCenterLocation)
VALUES  ('SM1', 'Main Saw Mill');

INSERT INTO WorkCenter_T  (WorkCenterID, WorkCenterLocation)
VALUES  ('WR1', 'Warehouse and Receiving');

INSERT INTO WorkCenter_T  (WorkCenterID, WorkCenterLocation)
VALUES  ('Tampa1', 'Tampa Warehouse');


INSERT INTO WorksIn_T (EmployeeID, WorkCenterID)
VALUES ('123-44-345', 'SM1');
INSERT INTO WorksIn_T (EmployeeID, WorkCenterID)
VALUES ('454-56-768', 'Tampa1');



INSERT INTO ProductLine_T  (ProductLineID, ProductLineName)
VALUES  (1, 'Basic');
INSERT INTO ProductLine_T  (ProductLineID, ProductLineName)
VALUES  (2, 'Antique');
INSERT INTO ProductLine_T  (ProductLineID, ProductLineName)
VALUES  (3, 'Modern');
INSERT INTO ProductLine_T  (ProductLineID, ProductLineName)
VALUES  (4, 'Classical');
INSERT INTO ProductLine_T  (ProductLineID, ProductLineName)
VALUES  (5, 'Rellville');
INSERT INTO ProductLine_T  (ProductLineID, ProductLineName)
VALUES  (6, 'Spanish Style');
INSERT INTO ProductLine_T  (ProductLineID, ProductLineName)
VALUES  (7, 'Gothic');



--REM INSERTING into Product_T
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (1,'Cherry End Table','Cherry',175.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (2,'Birch Coffee Tables','Birch',200.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (3,'Oak Computer Desk','Oak',750.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (4,'Entertainment Center','Cherry',1650.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (5,'Writer''s Desk','Oak',325.00,0,2);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (6,'8-Drawer Dresser','Birch',750.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (7,'48 Bookcase','Walnut',150.00,0,3);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (8,'48 Bookcase','Oak',175.00,0,3);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (9,'96 Bookcase','Walnut',225.00,0,3);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (10,'96 Bookcase','Oak',200.00,0,3);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (11,'4-Drawer Dresser','Oak',500.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (12,'8-Drawer Dresser','Oak',800.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (13,'Nightstand','Cherry',150.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (14,'Writer''s Desk','Birch',300.00,0,2);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (17,'High Back Leather Chair','Leather',362.00,0,3);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (18,'6'' Grandfather Clock','Oak',890.00,0,4);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (19,'7'' Grandfather Clock','Oak',1100.00,0,4);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (20,'Amoire','Walnut',1200.00,0,2);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (21,'Pine End Table','Pine',256.00,0,1);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (24,null,null,0.00,0,5);
Insert into Product_T (ProductID,ProductDescription,ProductFinish,ProductStandardPrice,ProductOnHand,ProductLineID) 
values (25,null,null,0.00,0,2);




INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (1, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (2, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (3, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (4, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (5, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (6, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (7, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (8, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (9, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (10, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (11, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (12, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (13, 'Tampa1');
INSERT INTO ProducedIn_T (ProductID, WorkCenterID)
	VALUES (14, 'Tampa1');


--REM INSERTING into CustomerShipAddress_T
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (1,4,13,'35456 Trifly Road','Lutz','FL','33549',null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (2,4,13,'1925 Beltline Rd.','Carteret','NJ',null,null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (3,1,6,'321 Butterfly Terr','Columbus','OH',null,null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (4,1,6,'7744 121 Street','Colubus','OH',null,null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (9,8,15,'US Embassy','Mexico City','Me',null,null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (10,16,4,'1256 One Lane','San Diego','CA','55555-',null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (11,9,1,'17832 Rt 92','Mobil','AL','39889-',null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (13,14,5,'303 Drakes Landing','Manhattan','KS','66502-',null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (14,13,2,'3400 Amador Ave','Las Cruces','NM','88001-',null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (15,4,6,'657 10th st','Kodiak','AK','99878-',null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (17,9,5,'100 E. Fletch','Pocahatas','OH','39877-',null);
Insert into CustomerShipAddress_T (ShipAddressID,CustomerID,TerritoryID,ShipAddress,ShipCity,ShipState,ShipZip,ShipDirections) values (19,4,13,'655 Rocky Point','Denver','CO',null,null);



INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (1, to_Date('08/Sep/09', 'DD/MON/RR'), 4, to_date('25/Nov/05', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (2, to_date('04/Oct/09', 'DD/MON/RR'), 3, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (3, to_date('19/Jul/09', 'DD/MON/RR'), 1, to_date('', 'DD/MON/RR'), 2, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (4, to_date('01/Nov/09', 'DD/MON/RR'), 6, to_date('', 'DD/MON/RR'), 5, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (5, to_date('28/Jul/09', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (6, to_Date('27/Aug/09', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (7, to_date('16/Sep/09', 'DD/MON/RR'), 1, to_date('', 'DD/MON/RR'), 2, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (8, to_date('16/Sep/09', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (9, to_date('16/Sep/09', 'DD/MON/RR'), 6, to_date('', 'DD/MON/RR'), 5, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (19, to_date('05/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (20, to_date('06/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (21, to_date('06/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (22, to_date('06/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (23, to_date('06/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (24, to_date('10/Mar/10', 'DD/MON/RR'), 1, to_date('', 'DD/MON/RR'), 2, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (25, to_date('10/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (26, to_date('10/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (27, to_date('10/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (28, to_date('10/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (29, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (30, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, 4);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (31, to_date('11/Mar/10', 'DD/MON/RR'), 15, to_date('', 'DD/MON/RR'), 4, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (32, to_date('11/Mar/10', 'DD/MON/RR'), 15, to_date('', 'DD/MON/RR'), 4, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (34, to_date('11/Mar/10', 'DD/MON/RR'), 15, to_date('', 'DD/MON/RR'), 4, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (35, to_date('11/Mar/10', 'DD/MON/RR'), 8, to_date('', 'DD/MON/RR'), 5, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (36, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, 1);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (37, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (38, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, 1);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (39, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, 1);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (40, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (41, to_date('11/Mar/10', 'DD/MON/RR'), 12, to_date('', 'DD/MON/RR'), 6, NULL);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (42, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, NULL);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (43, to_date('11/Mar/10', 'DD/MON/RR'), 12, to_date('', 'DD/MON/RR'), 6, NULL);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (44, to_date('11/Mar/10', 'DD/MON/RR'), 6, to_date('', 'DD/MON/RR'), 9, NULL);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (45, to_date('11/Mar/10', 'DD/MON/RR'), 12, to_date('', 'DD/MON/RR'), 6, NULL);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (46, to_date('11/Mar/10', 'DD/MON/RR'), 1, to_date('', 'DD/MON/RR'), 2, NULL);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (47, to_date('11/Mar/10', 'DD/MON/RR'), 12, to_date('', 'DD/MON/RR'), 6, NULL);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (48, to_date('11/Mar/10', 'DD/MON/RR'), 1, to_date('', 'DD/MON/RR'), 2, 3);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (49, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 3, 2);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (50, to_date('11/Mar/10', 'DD/MON/RR'), 8, to_date('', 'DD/MON/RR'), null, 9);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (51, to_date('11/Mar/10', 'DD/MON/RR'), 16, to_date('', 'DD/MON/RR'), null, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (52, to_date('11/Mar/10', 'DD/MON/RR'), 16, to_date('', 'DD/MON/RR'), null, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (53, to_date('11/Mar/10', 'DD/MON/RR'), 16, to_date('', 'DD/MON/RR'), null, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (54, to_date('11/Mar/10', 'DD/MON/RR'), 16, to_date('', 'DD/MON/RR'), 9, 10);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (55, to_date('11/Mar/10', 'DD/MON/RR'), 16, to_date('', 'DD/MON/RR'), null, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (56, to_date('11/Mar/10', 'DD/MON/RR'), 9, to_date('', 'DD/MON/RR'), 2, 11);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (57, to_date('11/Mar/10', 'DD/MON/RR'), 9, to_date('', 'DD/MON/RR'), null, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (58, to_date('11/Mar/10', 'DD/MON/RR'), 14, to_date('', 'DD/MON/RR'), 5, 13);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (59, to_date('11/Mar/10', 'DD/MON/RR'), 13, to_date('', 'DD/MON/RR'), 8, 14);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (63, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 6, 15);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (64, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 6, 2);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (65, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 6, 1);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (66, to_date('11/Mar/10', 'DD/MON/RR'), 9, to_date('', 'DD/MON/RR'), 5, 17);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (69, to_date('11/Mar/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), 2, 2);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (71, to_date('08/Sep/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), null, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (73, to_date('08/Sep/10', 'DD/MON/RR'), 12, to_date('', 'DD/MON/RR'), null, null);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (75, to_date('08/Sep/10', 'DD/MON/RR'), 1, to_date('', 'DD/MON/RR'), null, 3);

INSERT INTO Order_T (OrderID, OrderDate, CustomerID, FulfillmentDate, SalespersonID, ShipAdrsID) 
VALUES (76, to_date('15/Sep/10', 'DD/MON/RR'), 4, to_date('', 'DD/MON/RR'), null, null);




--REM INSERTING into OrderLine_T
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (1,1,2,18);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (31,1,6,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (2,1,10,9);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (3,2,3,12);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (4,2,8,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (5,2,14,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (17,3,2,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (7,4,3,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (15,4,4,0);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (8,4,5,3);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (16,4,6,3);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (29,5,1,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (9,5,6,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (37,24,1,0);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (39,25,2,5);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (40,26,1,5);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (41,28,1,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (42,32,5,10);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (43,32,14,10);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (46,39,2,3);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (51,48,17,5);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (54,49,1,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (53,50,20,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (55,51,3,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (56,51,4,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (57,52,1,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (58,52,4,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (59,54,2,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (60,54,3,3);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (61,55,1,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (62,55,4,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (63,56,4,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (64,58,3,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (65,59,13,2);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (66,63,3,5);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (67,65,4,0);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (68,66,4,1);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (69,69,7,4);
Insert into OrderLine_T (OrderLineID,OrderID,ProductID,OrderedQuantity) values (70,71,3,0);


--REM INSERTING INTO Shipped_T TABLE
INSERT INTO Shipped_T (OrderLineID, ShippedQuantity, ShippedDate) 
VALUES (1, 1, to_date('16/Sep/10 ', 'DD/MON/YY'));

INSERT INTO Shipped_T (OrderLineID, ShippedQuantity, ShippedDate) 
VALUES (2, 0, to_date('', 'DD/MON/YY'));

INSERT INTO Shipped_T (OrderLineID, ShippedQuantity, ShippedDate) 
VALUES (3, 1, to_date('16/Sep/10 ', 'DD/MON/YY'));

INSERT INTO Shipped_T (OrderLineID, ShippedQuantity, ShippedDate) 
VALUES (5, 2, to_date('16/Sep/10', 'DD/MON/YY'));


--REM INSERTING INTO PaymentType_T TABLE
INSERT INTO PaymentType_T (PaymentTypeID, TypeDescription) 
VALUES ('D', 'Deposit');

INSERT INTO PaymentType_T (PaymentTypeID, TypeDescription) 
VALUES ('R', 'Refund');

INSERT INTO PaymentType_T (PaymentTypeID, TypeDescription) 
VALUES ('T', 'Transfer');


--REM INSERTING INTO Payment_T TABLE
INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (1, 1, to_date('01/Mar/10', 'DD/MON/YY'), 'D', 1000.0, 'chk101');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (2, 24, to_date('10/Mar/10', 'DD/MON/YY'), 'D', 25.0, 'cash');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (3, 26, to_date('10/Mar/10', 'DD/MON/YY'), 'D', 222.0, 'cash');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (4, 28, to_date('10/Mar/10', 'DD/MON/YY'), 'D', 25.0, 'cash');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (5, 32, to_date('11/Mar/10', 'DD/MON/YY'), 'D', 3000.0, 'Cashiers Check');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (6, 34, to_date('11/Mar/10', 'DD/MON/YY'), 'D', 575.0, 'Chk1201');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (7, 39, to_date('11/Mar/10', 'DD/MON/YY'), 'D', 600.0, 'chk 1003');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (8, 48, to_date('11/Mar/10', 'DD/MON/YY'), 'D', 1000.0, 'chk2301');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (9, 51, to_date('11/Mar/10', 'DD/MON/YY'), 'D', 150.0, 'cash');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (10, 54, to_date('11/Mar/10', 'DD/MON/YY'), 'D', 2650.0, 'Check # 343');

INSERT INTO Payment_T (PaymentID, OrderID, PaymentDate, PaymentTypeID, PaymentAmount, PaymentComment) 
VALUES (11, 69, to_date('11/Mar/10', 'DD/MON/YY'), 'D', 200.0, 'chk3001');




INSERT INTO Vendor_T
(VendorID, VendorName, VendorAddress, VendorCity, VendorState, VendorZipcode, VendorPhone, VendorFax, VendorContact, VendorTaxIDNumber)
Values (1, 'Robert''s Lumber Yard', '1234 Wooded Lane', 'Forest Hill', 'TN', '33333-', '333-333-3333', '', 'Robert', '123456789');
INSERT INTO Vendor_T
(VendorID, VendorName, VendorAddress, VendorCity, VendorState, VendorZipcode, VendorPhone, VendorFax, VendorContact, VendorTaxIDNumber)
Values (2, 'Southern Lumber', '8768 Durgee Rd', 'Jacksonville', 'FL', '25998-', '444-444-4444', '', '', '');
INSERT INTO Vendor_T
(VendorID, VendorName, VendorAddress, VendorCity, VendorState, VendorZipcode, VendorPhone, VendorFax, VendorContact, VendorTaxIDNumber)
Values (3, 'Pebbles Hardware', '2323 Hardrock Rd', 'Bedrock', 'TX', '77777-', '555-555-5555', '', '', '');


/* run basic queries over every table to verify data               */


SELECT * FROM Vendor_T;
SELECT * FROM Payment_T;
SELECT * FROM PaymentType_T;
SELECT * FROM Shipped_T;
SELECT * FROM OrderLine_T;
SELECT * FROM Order_T;
SELECT * FROM CustomerShipAddress_T;
SELECT * FROM ProducedIn_T;
SELECT * FROM Product_T;
SELECT * FROM ProductLine_T;
SELECT * FROM WorksIn_T;
SELECT * FROM WorkCenter_T;
SELECT * FROM EmployeeSkills_T;
SELECT * FROM Employee_T;
SELECT * FROM Skill_T;
SELECT * FROM Salesperson_T;
SELECT * FROM DoesBusinessIn_T;
SELECT * FROM Territory_T;
SELECT * FROM Customer_T;


DROP TABLE Supplies_T 		        CASCADE CONSTRAINTS ;
DROP TABLE Uses_T 		            CASCADE CONSTRAINTS ;
DROP TABLE RawMaterial_T 	        CASCADE CONSTRAINTS ;
DROP TABLE Vendor_T 		          CASCADE CONSTRAINTS ;
DROP TABLE Shipped_T              CASCADE CONSTRAINTS ;
DROP TABLE PaymentType_T          CASCADE CONSTRAINTS ;
DROP TABLE Payment_T              CASCADE CONSTRAINTS ;
DROP TABLE CustomerShipAddress_T  CASCADE CONSTRAINTS ;


COMMIT;