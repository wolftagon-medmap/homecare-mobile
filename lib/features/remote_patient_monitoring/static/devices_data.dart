import 'package:m2health/features/remote_patient_monitoring/enums/vital_category.dart';
import 'package:m2health/features/remote_patient_monitoring/models/device_model.dart';

class DevicesData {
  static const List<Device> allDevices = [
    // Polar
    Device(
      name: 'Polar H7 Heart Rate Sensor',
      imageUrl:
          'https://lh5.googleusercontent.com/proxy/LksHTWtmIy8CuQS34EqeL4CtuBI0Lh3AY86Bk2HilSMB0W8sTCJ517j36phMRn5JkL2Hv5CJTJn1qSnnoD8_cOkPcbO7m41sypoxg6M3T40cRODmWCL1hybeebGdj1ILwiOqfBlJQcr5-QoeJtfVJG3xC6PLIRU',
      description:
          'Reliable heart rate sensor for precise tracking during workouts.',
      supportedVitals: [VitalCategory.heartPerformance],
      brandDisplayName: 'Polar',
      brandCode: 'polar',
    ),
    Device(
      name: 'Polar H10 Heart Rate Sensor',
      imageUrl:
          'https://www.polar.com/img/static/h10-next/webp/gallery/red-2.webp',
      description: 'The most accurate heart rate sensor in Polar history.',
      supportedVitals: [VitalCategory.heartPerformance],
      brandDisplayName: 'Polar',
      brandCode: 'polar',
    ),
    Device(
      name: 'Polar Verity Sense',
      imageUrl:
          'https://ourpolar.com/cdn/shop/products/polar-verity-sense-sensor-and-armband-2-1500x1500-removebg-preview.png?v=1659077473',
      description:
          'Optical heart rate sensor that provides maximum freedom of movement.',
      supportedVitals: [VitalCategory.heartPerformance],
      brandDisplayName: 'Polar',
      brandCode: 'polar',
    ),

    // Omron
    Device(
      name: 'Omron Blood Pressure Monitor',
      imageUrl:
          'https://omronhealthcare.com/storage/products/bp5000-hero-1000x1000.png',
      description: 'Standard upper arm blood pressure monitor for home use.',
      supportedVitals: [VitalCategory.bloodPressure],
      brandDisplayName: 'Omron',
      brandCode: 'omron',
    ),
    Device(
      name: 'Omron Evolv Wireless Upper Arm Blood Pressure Monitor',
      imageUrl:
          'https://omronhealthcare.com/images/fit=crop-50-50,fm=jpg,h=630,w=1200/products/bp7000-hero-800x800.png?signature=a484049975d257fe1f41c436a63458cff19c35efae51b774404168f2ab3f8f2c',
      description: 'Compact, all-in-one wireless blood pressure monitor.',
      supportedVitals: [VitalCategory.bloodPressure],
      brandDisplayName: 'Omron',
      brandCode: 'omron',
    ),
    Device(
      name: 'Omron Platinum Blood Pressure Monitor',
      imageUrl:
          'https://omronhealthcare.com/storage/products/bp5465-front-2000x2000.jpg',
      description:
          'Premium blood pressure monitor with high accuracy and memory.',
      supportedVitals: [VitalCategory.bloodPressure],
      brandDisplayName: 'Omron',
      brandCode: 'omron',
    ),

    // Nonin
    Device(
      name: 'Nonin Pulse Oximeter',
      imageUrl:
          'https://www.nonin.com/wp-content/uploads/beans/images/Product-Image-PNG-3230_Front-angled-left-0a766af.jpg',
      description: 'Highly accurate SpO2 and pulse rate sensor.',
      supportedVitals: [VitalCategory.bloodOxygen],
      brandDisplayName: 'Nonin',
      brandCode: 'nonin',
    ),
    Device(
      name: 'Nonin Onyx Vantage 9590',
      imageUrl:
          'https://www.nonin.com/wp-content/uploads/beans/images/Onyx-II-and-Onyx-Vantage-Front-0a766af.jpg',
      description: 'Professional-grade finger pulse oximeter for clinical use.',
      supportedVitals: [VitalCategory.bloodOxygen],
      brandDisplayName: 'Nonin',
      brandCode: 'nonin',
    ),

    // Roche
    Device(
      name: 'Roche Accu-Chek Glucose Meter',
      imageUrl:
          'https://www.accu-chek.com.ph/sites/g/files/iut1061/f/styles/image_300x400/public/active-mgdl-300x400.png',
      description: 'Simple and reliable glucose monitoring system.',
      supportedVitals: [VitalCategory.bloodGlucose],
      brandDisplayName: 'Roche',
      brandCode: 'roche',
    ),
    Device(
      name: 'Accu-Chek Guide Me',
      imageUrl:
          'https://www.accu-chek.com/sites/g/files/papvje226/files/2023-06/Guide%20Me%20meter%20500x500.png',
      description:
          'Easy-to-use blood glucose meter with Bluetooth connectivity.',
      supportedVitals: [VitalCategory.bloodGlucose],
      brandDisplayName: 'Roche',
      brandCode: 'roche',
    ),
    Device(
      name: 'Accu-Chek Instant',
      imageUrl:
          'https://www.accu-chek.co.id/sites/g/files/iut1091/f/styles/image_300x400/public/instant-mgdl-300x400_0.png?itok=ecRQ6ARm',
      description: 'Instant clarity with a visual target range indicator.',
      supportedVitals: [VitalCategory.bloodGlucose],
      brandDisplayName: 'Roche',
      brandCode: 'roche',
    ),

    // Withings
    Device(
      name: 'Withings Body+ Scale',
      imageUrl:
          'https://image-cache.withings.com/site/media/wi_products/body-plus-black.png?w=500',
      description: 'Wi-Fi Smart Scale that tracks body composition and weight.',
      supportedVitals: [VitalCategory.heartPerformance],
      brandDisplayName: 'Withings',
      brandCode: 'withings',
    ),
    Device(
      name: 'Withings BPM Connect',
      imageUrl:
          'https://www-assets.withings.com/pages/products/bpm-connect/media/hero_2024/bpmconnect_hero.jpg',
      description:
          'Wi-Fi smart blood pressure monitor with immediate feedback.',
      supportedVitals: [VitalCategory.bloodPressure],
      brandDisplayName: 'Withings',
      brandCode: 'withings',
    ),

    // Apple
    Device(
      name: 'Apple Watch Series 8',
      imageUrl:
          'https://cdsassets.apple.com/live/SZLF0YNV/images/sp/111848_apple-watch-series8.png',
      description:
          'Advanced smartwatch with heart rate and blood oxygen tracking.',
      supportedVitals: [
        VitalCategory.heartPerformance,
        VitalCategory.bloodOxygen
      ],
      brandDisplayName: 'Apple',
      brandCode: 'apple',
    ),
    Device(
      name: 'Apple Watch Ultra',
      imageUrl:
          'https://cdsassets.apple.com/live/SZLF0YNV/images/sp/111852_apple-watch-ultra.png',
      description:
          'The most rugged and capable Apple Watch for extreme monitoring.',
      supportedVitals: [
        VitalCategory.heartPerformance,
        VitalCategory.bloodOxygen
      ],
      brandDisplayName: 'Apple',
      brandCode: 'apple',
    ),
  ];
}
