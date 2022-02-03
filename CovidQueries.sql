SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY location, date;

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in a certain country

SELECT location, date, total_cases, total_deaths, round((total_deaths::DECIMAL/total_cases)*100,2) as DeathPerc
FROM coviddeaths
WHERE location ILIKE '%states%'
ORDER BY location, date;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date, total_cases, population, round((total_cases::DECIMAL/population)*100,2) as DeathPerc
FROM coviddeaths
WHERE location ILIKE '%states%'
ORDER BY location, date;

-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as highestinfectioncount, round(max((total_cases::DECIMAL/population))*100,2) as percentinfected
FROM coviddeaths
--WHERE location ILIKE '%states%'
GROUP BY location, population
ORDER BY percentinfected DESC;

--Showing Countries with Highest Death Count per population

SELECT location, MAX(total_deaths::INTEGER) as TotalDeathCount
FROM coviddeaths
--WHERE location ILIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--BY Continent
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--Global Numbers
SELECT SUM(new_cases), SUM(new_deaths::INTEGER), ROUND(SUM(new_deaths::DECIMAL)/SUM(new_cases::INTEGER)*100,2) as deathpercofcases
FROM coviddeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1;

-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations::INTEGER) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingCount
FROM coviddeaths as dea
JOIN covidvaccinations as vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
ORDER BY 2, 3;


