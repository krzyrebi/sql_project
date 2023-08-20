
Select *
from CovidDeaths


select * 
from CovidVaccinations
order by location, date

-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT))*100 AS death_rate
from CovidDeaths
Where location like '%korea%'
order by 1,2


-- Total cases vs population

Select location, date, total_cases, total_deaths, population, (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))*100 AS infection_rate
from CovidDeaths
Where location like '%korea%'
order by 1,2

-- countries with highest infection rate on a given date

Select location, date, total_cases, total_deaths, population, (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))*100 AS infection_rate
from CovidDeaths
where date='2023-06-12'
order by infection_rate desc


-- countries with highest infection rate 

Select location, population, MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))*100) AS  Max_Population_infected_ratio
from CovidDeaths
Group by location, population
order by Max_Population_infected_ratio desc


--countries with highest death ratio per Population

Select location, population, MAX((CAST(total_deaths AS FLOAT) / CAST(population AS FLOAT))*100) AS  Max_death_ratio
from CovidDeaths
Group by location, population
order by Max_death_ratio desc


-- countries with highest deatchcount
Select location, population, MAX(CAST(total_deaths AS INT)) AS  Max_death_count
from CovidDeaths
where continent is not null
Group by location, population
order by Max_death_count desc

-- deathcount by continent
Select location, population, MAX(CAST(total_deaths AS INT)) AS  Max_death_count
from CovidDeaths
where continent is null and location not like '%income%' and location not like '%world%' and location not like '%union%'
Group by location, population
order by Max_death_count desc

-- different approach
Select continent, MAX(CAST(total_deaths AS INT)) AS  Max_death_count
from CovidDeaths
where continent is not null
Group by continent
order by Max_death_count desc

-- Global data - cases by date - global
Select date, sum(CAST(total_cases AS INT)) AS Total_cases_by_date
from CovidDeaths
where continent is null and location not like '%income%' and location not like '%world%' and location not like '%union%' 
Group by date
order by date asc

--join tables - vaccination rate
Select dea.location, dea.date, Cast(vac.people_vaccinated as BIGINT), Cast(vac.people_vaccinated as FLOAT)/Cast(dea.population as FLOAT)*100 as Vaccinations_rate
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
order by dea.location, dea.date


select * from CovidVaccinations
order by location, date


--Rolling vaccination count
Select dea.location, dea.date, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location order By dea.date) as RollingVaccinations
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
order by dea.location, dea.date



--cte

With PopVac (location, date, new_vaccinations, population, RollingVaccinations)
as
(
Select dea.location, dea.date, vac.new_vaccinations, dea.population, SUM(Cast(vac.new_vaccinations as BIGINT)) OVER (Partition by dea.location order By dea.location, dea.date) as RollingVaccinations
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
)

Select *, (RollingVaccinations/population)*100 as VaccinationRatio
from PopVac
order by location, date





