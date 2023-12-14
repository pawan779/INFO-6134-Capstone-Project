//
//  AppointmentViewModel.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//


import Foundation

class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    
    private var databaseHelper = DatabaseHelper.shared
    
    init() {
        fetchAppointments()
    }
    
    func fetchAppointments() {
        appointments = databaseHelper.fetchAppointments()
    }
    
    
    // Gesture : Shake tips array
    let healthTips = [
        "Prioritize quality sleep for optimal physical and mental health.",
        "Incorporate omega-3 fatty acids into your diet for brain and heart health.",
        "Practice mindfulness meditation to reduce stress and improve focus.",
        "Engage in regular aerobic exercise to support cardiovascular health.",
        "Include a variety of colorful vegetables in your meals for diverse nutrient intake.",
        "Consume probiotics for a healthy gut microbiome and improved digestion.",
        "Stay hydrated by drinking an adequate amount of water throughout the day.",
        "Limit processed foods and choose whole, nutrient-dense options.",
        "Consider incorporating intermittent fasting for metabolic health benefits.",
        "Get regular check-ups and screenings to detect health issues early.",
        "Maintain a healthy weight through a balanced diet and regular exercise.",
        "Include strength training in your fitness routine to build and maintain muscle mass.",
        "Practice good posture to prevent musculoskeletal issues and back pain.",
        "Limit added sugars in your diet to reduce the risk of chronic diseases.",
        "Take breaks from screen time to protect your eyes and reduce digital eye strain.",
        "Stay socially connected to support mental and emotional well-being.",
        "Consider personalized genetic testing for insights into your health risks.",
        "Optimize vitamin D levels through sun exposure or supplements for bone health.",
        "Stay informed about the latest advancements in health and wellness research.",
        "Consult with healthcare professionals for personalized health advice and plans."
    ]
    
    func addAppointment(_ appointment: Appointment) {
        databaseHelper.addAppointment(appointment: appointment)
        fetchAppointments()
    }
    
    func deleteAppointment(appointmentID: UUID) {
        databaseHelper.deleteAppointment(appointmentId: appointmentID)

        fetchAppointments()
    }
    
    func deleteAllAppointments(){
        databaseHelper.deleteAllAppointments()
        fetchAppointments()
    }
}
