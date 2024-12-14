Select * 
From PortfolioProject..CovidDeaths
Order By 3,4 -- column 3 and 4 k according sort krdo


Select * 
From PortfolioProject..CovidVaccinations
Order By 3,4


-- Selecting data that im going to use
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order By 1,2


-- Total Cases vs Total Deaths i.e likelihood of dying from covid
Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as CovidDeathPercentage
From PortfolioProject..CovidDeaths
Order By 1,2 


Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as CovidDeathPercentage
From PortfolioProject..CovidDeaths
Order By 6 DESC


Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as CovidDeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states'
Order By 1,2


Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as CovidDeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'Pakistan'
Order By 1,2


-- Countries with highest covid cases per population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPopulationPercent
From PortfolioProject..CovidDeaths
Group By location, population
Order By InfectedPopulationPercent DESC


-- Countries with highest Covid per population
Select location, population, MAX(total_deaths) as HighestDeathCount, MAX((total_deaths/population))*100 as InfectedDeathPopulationPercent
From PortfolioProject..CovidDeaths
Group By location, population
Order By InfectedDeathPopulationPercent DESC


-- Global Data
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
From PortfolioProject..CovidDeaths


-- Global Data on each date
Select date ,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
From PortfolioProject..CovidDeaths
Where continent is not null
Group By date
Order By date


--Vaccinations per day
Select cd.Continent, cd.Location, cd.Date, cd.Population, cv.New_Vaccinations, 
SUM(Convert(int,cv.new_vaccinations)) Over(Partition by cd.location Order By cd.Location, 
cd.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
	On cd.location = cv.location
	and cd.date = cv.date
Where cd.continent is not null
order by 2,3


--Common Table Expression AKA CT
With PopvsVac as(
Select cd.Continent, cd.Location, cd.Date, cd.Population, cv.New_Vaccinations, 
SUM(Convert(int,cv.new_vaccinations)) Over(Partition by cd.location Order By cd.Location, 
cd.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
	On cd.location = cv.location
	And cd.date = cv.date
Where cd.continent is NOT NULL
--order by 2,3 --Order By throws error in CTEs
)

Select *, (RollingPeopleVaccinated/population)*100 as VacPerPop
From PopvsVac



-- Temp Table
Drop Table if exists #VacPerPop
Create Table #VacPerPop(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #VacPerPop
Select cd.Continent, cd.Location, cd.Date, cd.Population, cv.New_Vaccinations, 
SUM(Convert(int,cv.new_vaccinations)) Over(Partition by cd.location Order By cd.Location, 
cd.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
	On cd.location = cv.location
	And cd.date = cv.date
Where cd.continent is NOT NULL
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 as VacPerPop
From #VacPerPop
