String getAnimationForWeather(String iconCode) {
  switch (iconCode) {
    case '01d':
      return 'assets/animations/01d.json'; // Clear sky
    case '01n':
      return 'assets/animations/01n.json'; // Clear night
    case '02d':
      return 'assets/animations/02d.json'; // Few clouds
    case '02n':
      return 'assets/animations/02n.json';
    case '03d':
    case '03n':
      return 'assets/animations/03d.json'; // Scattered clouds
    case '04d':
    case '04n':
      return 'assets/animations/04d.json'; // Broken clouds
    case '09d':
    case '09n':
      return 'assets/animations/09d.json'; // Shower rain
    case '10d':
    case '10n':
      return 'assets/animations/10d.json'; // Rain
    case '11d':
    case '11n':
      return 'assets/animations/11d.json'; // Thunderstorm
    case '13d':
    case '13n':
      return 'assets/animations/13d.json'; // Snow
    case '50d':
    case '50n':
      return 'assets/animations/50d.json'; // Mist/Fog
    default:
      return 'assets/animations/01d.json'; // fallback
  }
}
