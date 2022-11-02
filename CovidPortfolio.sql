

select *
from    PortfolioProject..CovidDeaths
where continent is not null
order by 3,4



--select *
--from    PortfolioProject..CovidVaccine
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population   from  PortfolioProject..CovidDeaths
order by 1,2

-- Looking for the total cases Vs total deaths by percent
-- Likelihood of dying if you contact covid in your country

select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_percentage
from PortfolioProject..CovidDeaths
where location like '%Asia%'
order by 1,2


--Shows what percentage of population got infected by Covid
--Looking at the total cases bs population

Select Location, date, total_cases, population, (total_cases/population)*100 as Percent_of_population_infected
from Portfolioproject.dbo.CovidDeaths
where location like '%Australia%'
order by 1,2


--Looking at the countries with the highest infection rate compared to the total population


Select Location, Max(total_cases) as Highest_infection_count , Max ((total_cases/population))*100 as Percent_of_population_infected
from Portfolioproject..CovidDeaths
group by Location, population
order by Percent_of_population_infected  desc


-- Showing countries with highest death counts per population

Select Location, Max(cast(Total_deaths as int)) as Total_death_count
from Portfolioproject..CovidDeaths
where continent is not null
group by Location
order by Total_death_count desc

--Breaking things down by continent , Showing continent with highest death count per population

Select continent, Max(cast(Total_deaths as int)) as Total_death_count
from Portfolioproject..CovidDeaths
where continent is not null
group by continent
order by Total_death_count desc

-- Global Numbers

select  Sum(new_cases) as total_cases, Sum(new_deaths ) as total_deaths, sum(new_deaths_smoothed )/ Sum(new_cases)*100 as Death_percentage
from Portfolioproject..CovidDeaths
--where new_cases is not null
--group by date
order by 1,2

-- Covid vaccine
select *
from PortfolioProject..CovidVaccine

Select * 
from PortfolioProject..VaccineSheet2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
	



