--select *
--from CovidDeaths$


----select *
----from CovidVaccination
----order by 3,4
--covid 19 data exapolation--

select *
from CovidDeaths$
where continent is not null
order by 3,4
-----select data that we gonna start with 
select location ,date,new_cases,total_deaths,population
from CovidDeaths$
where continent is not null
order by 1,2
---look at the total case vs death
--show likelihood of dying if you contract covid in your country
select location ,date,new_cases,total_deaths,population,(total_deaths/total_cases)*100 as dearhprecetage
from CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2

---look at the total case vs population
--shows what precentage of population got covid
select location ,date,new_cases,population,(total_cases/population)*100 as casesprecetage
from CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2

---looking at countries with  hiesght infection rate compar to population
select location ,population,MAX(total_cases)as Highestinfactioncount,max(total_cases/population)*100 as precetagepopualtionunfact
from CovidDeaths$
where continent is not null
group by location , population
order by precetagepopualtionunfact desc

---showing contries highest death count per population
select location ,population,max(cast (total_deaths as int))as HighestDeathscount
from CovidDeaths$
where continent is not null
group by location , population
order by HighestDeathscount desc

-------showing continent with highest death count per population
select continent ,max(cast (total_deaths as int))as HighestDeathscount
from CovidDeaths$
where continent is not null
group by continent
order by HighestDeathscount desc

----- GLuble Numbers

select sum(cast(new_cases as int))as total_cases,sum(cast(total_deaths as int))as total_death,(sum(cast(total_deaths as int))/sum(cast(new_cases as int)))*100 as dearhprecetage
from CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

---- show total pupolation vs viccination

--use CTE TABLE
with popvsvac(continent,location,date,population,new_vaccination,RollingPeapleVaccination)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int))over (partition by dea.location order by dea.location ,dea.date)as RollingPeapleVaccination
--, (RollingPeapleVaccination/dea.population)*100
from CovidDeaths$ dea join  CovidVaccination vac
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null
--order by 1,3
)
select *,(RollingPeapleVaccination/population)*100
from popvsvac


----create view to store data for later  visualization

create view PrecentPopulationVaccination as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int))over (partition by dea.location order by dea.location ,dea.date)as RollingPeapleVaccination
--, (RollingPeapleVaccination/dea.population)*100
from CovidDeaths$ dea join  CovidVaccination vac
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null
--order by 1,3

select * 
from PrecentPopulationVaccination