//
//  MedicationListView.swift
//  MedWise
//
//  Created by Pawan Dharel on 10/21/23.
//

import SwiftUI

struct MedicationListView: View {

    @ObservedObject var viewModel = MedicationListViewModel()
    @State private var showAlert = false
    
    func fetchMedicine(){
        viewModel.fetchMedications()
    }


    @State private var isRecording = false
    @State private var showModal = false

    var body: some View {
        NavigationView{
            ZStack{
                Color.customBackgroundColor
                    .ignoresSafeArea()

                // Shake Features
                Text("")
                    .onShake {
                        print("Device shaken!")
                        showAlert = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Healthy Tips of the Day"),
                            message: Text(viewModel.healthTips.randomElement() ?? "No tips available"),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                
                VStack{
                    HStack {
                        ZStack(alignment: .trailing){
                            TextField(" Search Medicine", text: $viewModel.searchTerm)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .onChange(of: viewModel.searchTerm) { newValue in viewModel.filterSearchResults()
                                }

                            if !viewModel.searchTerm.isEmpty {
                                Button(action: {
                                    viewModel.searchTerm = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 20)
                                }
                            }
                        }

                        Button(action: {
                            self.showModal.toggle()
                            self.isRecording = false
                        }) {
                            Image(systemName: "speaker.wave.2.bubble.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.white)
                        }
                        .padding(.trailing,5)

                        Button(action: {
                            if viewModel.selectedFilterData.isEmpty && viewModel.selectedSortedValue.isEmpty {
                                viewModel.isFilterSheetPresented.toggle()
                            } else {
                                viewModel.selectedFilterData = ""
                                viewModel.selectedSortedValue = ""
                            }
                        }) {
                            Text("\((viewModel.selectedFilterData.isEmpty && viewModel.selectedSortedValue.isEmpty) ? "Filter" : "Clear")")
                            Image(systemName: (viewModel.selectedFilterData.isEmpty && viewModel.selectedSortedValue.isEmpty) ? "chevron.down" : "xmark.circle.fill" )
                                .padding(.top, 6)
                        }
                        .padding(.trailing, 10)
                        .foregroundColor(.white)
                        .sheet(isPresented: $viewModel.isFilterSheetPresented, content: {
                            MedicationFilterView(viewModel: viewModel)
                                .presentationDetents([.height(250)])

                        })
                        
                     
                    }

                    
                    

                    ScrollView
                    {
                        ForEach(viewModel.listData){medicine in
                            MedicationRow(medicine: medicine,viewModel: viewModel)
                        }
                        .padding(.vertical,20)

                    }
                    .onAppear(perform: {
                        viewModel.fetchMedications()
                    })

                    .sheet(isPresented: $viewModel.isPresented) {
                        AddMedicationView(viewModel:viewModel)
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.toggleAddMedication()
                            viewModel.isEditMode = false
                            viewModel.clear()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                                       .resizable()
                                                       .frame(width: 60, height: 60)
//                                                       .background(Circle())
                                                       .foregroundColor(.white)
                                                       .padding(.bottom, 60)
                                                       .padding(.trailing, 20)
                        }
                    }
                }
                
                
            }
            .sheet(isPresented: $showModal, content: {
                GeometryReader { geometry in
                    VStack {
                        
                        
                        Text("Text to Speech")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                        
                        Button(action: {
                            isRecording.toggle()
                            if( isRecording){
                                viewModel.readDescription()
                               
                            }
                            else {
                                viewModel.stopRecording()
                            }
                            
                            
                        }) {
                            
                            Image(systemName: !isRecording ? "circle.fill" : "stop.circle")
                                .font(.system(size: 50))
                                .foregroundColor(isRecording ? .red : .green)
                            
                            Text(isRecording ? "Stop" : "Start")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .padding()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.customBackgroundColor)
                }})
        }
                   

    }
}


// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}




#Preview {
    MedicationListView(viewModel: MedicationListViewModel())
}
