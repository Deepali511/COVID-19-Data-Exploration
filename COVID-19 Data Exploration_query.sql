--COVID Deaths 
Select Location, Date, convert(int,total_cases) as Total_Cases, New_Cases, convert(int,Total_deaths) as Total_Deaths 
from PortfolioProject..CovidDeaths
order by 1,2


--COVID Vaccinations 
Select Location, Date, convert(int,New_Vaccinations) as New_Vaccinations
from PortfolioProject..CovidVaccination
order by 1,2


--Total Cases VS Total Deaths in India
Select Location, Date, cast(Total_cases as int) as Total_cases, cast(Total_deaths as int) as Total_deaths, (convert(float,total_deaths) / convert(float,total_cases)) * 100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null and
location = 'india'
Order by 1,2 desc


--Total Cases VS Total Population in India
Select Location, Date, cast(Total_cases as int) as Total_cases, population, (cast(total_cases as int)/population)*100 as Infected_population_percentage
From PortfolioProject..CovidDeaths
Where continent is not null and
location = 'india'
Order by 1,2 desc


--Countries with Highest Infection Rate
Select location, population, max(cast(total_cases as int)) as Highest_Infection_Count, max(cast(total_cases as int)/population)*100 as Infected_population_percent
From PortfolioProject..CovidDeaths
Where continent is not null
group by location, population
Order by 4 desc


--Countries with Highest Death Count
Select location, max(cast(total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
Where continent is not null
group by location
Order by Total_Death_Count desc


--Continents with Highest Death Count
Select continent, max(cast(total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
Where continent is not null
group by continent
Order by Total_Death_Count desc


--Global Numbers of Covid Cases
Select sum(new_cases) as Total_cases, sum(new_deaths) as Total_deaths, (sum(new_deaths)/sum(new_cases))*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2


                                  --Total Population VS Vaccination
--Using CTE 
With PopvsVac
(Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(
Select cd.continent, cd.location, cd.date, cd.population, convert(int,cv.new_vaccinations) as new_vaccination,
sum(convert(bigint,cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccination cv
on cd.location = cv.location and 
cd.date = cv.date
Where cd.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--Using temp table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, convert(int,cv.new_vaccinations) as new_vaccination,
sum(convert(bigint,cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccination cv
on cd.location = cv.location and 
cd.date = cv.date
Where cd.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--Creating View
Create View PercentPopulationVaccinated as
Select cd.continent, cd.location, cd.date, cd.population, convert(int,cv.new_vaccinations) as new_vaccination,
sum(convert(bigint,cv.new_vaccinations)) Over (Partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccination cv
on cd.location = cv.location and 
cd.date = cv.date
Where cd.continent is not null





