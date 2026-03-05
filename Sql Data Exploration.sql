Select *
from [Portfolio project].[dbo].[CovidDeaths]
order by 3,4

--Select *
--from [Portfolio project].[dbo].[Covidvaccinations]
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio project].[dbo].[CovidDeaths]
Order by 1, 2

--- Looking at Total cases vs Total Deaths
--- Shows the likelihood of dying if you contract in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from [Portfolio project].[dbo].[CovidDeaths]
where location like '%Canada%'
Order by 1, 2

--- Looking at the total cases vs Population 
--- shows what percentage of people got COVID 

Select location, date, total_cases, total_deaths, (total_cases/population)*100 as percentpopulationinfected
from [Portfolio project].[dbo].[CovidDeaths]
where location like '%Canada%'
Order by 1, 2

--- Looking at the countries with highest infection rates compared to population

Select location, Population, Max(total_cases) as highestinfectioncount, Max((total_cases/population))*100 as percentpopulationinfected
from [Portfolio project].[dbo].[CovidDeaths]
where location like '%Canada%'
Group By location, Population
Order by percentpopulationinfected desc

--- showing the countries death count as per population

Select location, Max(cast(total_deaths as Int)) as totaldeathcount
from [Portfolio project].[dbo].[CovidDeaths]
where continent is not null
Group By location, Population
Order by totaldeathcount desc

--- Let's Break thing Down by continent

Select location, Max(cast(total_deaths as Int)) as totaldeathcount
from [Portfolio project].[dbo].[CovidDeaths]
where continent is not null
Group By location, Population
Order by totaldeathcount desc

--- Global numbers
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as Deathpercentage
from [Portfolio project].[dbo].[CovidDeaths]
where continent is not null
Group by date
Order by 1,2

--- Total number
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as Deathpercentage
from [Portfolio project].[dbo].[CovidDeaths]
where continent is not null
--Group by date
Order by 1,2

--- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location Order by dea.location, dea.date) as RollingpeopleVaccinated
From [Portfolio project]..CovidDeaths dea
join [Portfolio project]..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--- Use CTE

With  PopvsVac (Continent, Location, Date, Population,new_vaccinations, RollingpepleVaccinated)
As 
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location Order by dea.location, dea.date) as RollingpeopleVaccinated
From [Portfolio project]..CovidDeaths dea
join [Portfolio project]..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
---order by 2,3
)

Select *,(RollingpepleVaccinated/Population)*100
from PopvsVac


--- Temp Table

Drop Table if exists #Percentpopulationvaccinated

Create Table #Percentpopulationvaccinated
( continent nvarchar (255),
  Location nvarchar(255),
  Date Datetime,
  Population numeric,
  New_vaccinations numeric,
  Rollingpeoplevaccinated numeric
  )
Insert into #Percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location Order by dea.location, dea.date) as RollingpeopleVaccinated
From [Portfolio project]..CovidDeaths dea
join [Portfolio project]..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
--- where dea.continent is not null
---order by 2,3

Select *,(RollingpeopleVaccinated/Population)*100
from #Percentpopulationvaccinated





