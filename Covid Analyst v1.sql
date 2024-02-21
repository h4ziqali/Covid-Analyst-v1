--THIS PROJECT IS SHOWCASE MY ABILITY TO USE AND MAKE QUERY USING MYSQL. cc to Alex the Analyst

Select *
From [Covid Analyst]..[Covid Death]
Order by 3,4

Select *
From [Covid Analyst]..[Covid Death]
Order by 3,4

Select location, date, total_cases, total_deaths, population, new_cases
From [Covid Analyst]..[Covid Death]
Order by 1,2

--Total Cases vs Total Death

--Change nvachar data type to float for below operation
--Alter Table [Covid Death]
--Alter Column [total_deaths] float
--Alter Column [total_cases] float

--Calculate total death percentage vs total cases
Select location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 as Death_Percentage
From [Covid Analyst]..[Covid Death]
Order by 1,2

--Calculate total cases vs population
Select location, date, total_cases, population, (total_cases/population)*100 as Cases_Percentage
From [Covid Analyst]..[Covid Death]
--Where location like 'Malaysia'
Order by 1,2

--Countries with highest infection rate
Select location, population, MAX(total_cases) as Highest_Cases, MAX(total_cases/population)*100 as Infection_Percentage
From [Covid Analyst]..[Covid Death]
Group by location, population
Order by Infection_Percentage desc

--Countries with highest total death and death percentage
Select location, population, MAX(total_deaths) as Total_Death, MAX(total_deaths/population)*100 as Death_Percentage
From [Covid Analyst]..[Covid Death]
Where continent is not null 
--and location like 'Malaysia'
Group by location, population
Order by Total_Death desc

--Death Percentage across the world
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases) * 100 as Death_Percentage
From [Covid Analyst]..[Covid Death]
Where continent is not null
order by 1,2

--Join table
Select *
From [Covid Analyst]..[Covid Death] dea
Join [Covid Analyst]..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date

--World Population that has been vaccinated

--Using CTE
With PopvsVac (Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Covid Analyst]..[Covid Death] dea
Join [Covid Analyst]..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
	Where dea.location is not null
	--Order by 1,2
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Using Temp Table
Drop Table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(
Location nvarchar(255),
Date datetime,
Population float,
New_Vaccination float,
RollingPeopleVaccinated numeric
)

Insert into #PercentPeopleVaccinated
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From [Covid Analyst]..[Covid Death] dea
Join [Covid Analyst]..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
	Where dea.location is not null	
	--Order by 1,2

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPeopleVaccinated
