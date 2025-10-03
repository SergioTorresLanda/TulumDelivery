//
//  MapView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 12/06/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var viewmodel: MyViewModel
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) var dismiss
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var showPermissionAlert = false
    @State private var alertMessage = ""
    @State private var coordinateG: CLLocationCoordinate2D?
    @State private var adressText = ""
    @State private var pMethod = ""
    @State private var deliveryId: String = ""

    var body: some View {
        VStack{
            Divider()
            Text(viewmodel.isDelivery ? "Step 4. Wait for your stuff and confirm delivery reception." : "Step 3. Confirm your delivery place and select a payment method.").font(.system(size: 20))//.background(Color(.gray))
            Divider()
            ZStack{
                Map(position: $cameraPosition) {
                    UserAnnotation()
                    // Add markers and annotations declaratively
                    //Marker("Mexico City Zocalo", coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332))
                }.mapControls {
                    // Añade controles como la brújula y el botón para centrar en el usuario.
                    MapUserLocationButton()
                    MapCompass()
                }
                .onAppear {
                    // Al aparecer la vista, pedimos permiso.
                    locationManager.requestLocationPermission()
                    
                }
                .onChange(of: locationManager.location) { oldValue, newValue in
                    // Cuando obtenemos una nueva ubicación del usuario, centramos el mapa ahí.
                    if let coordinate = newValue?.coordinate {
                        print("Centrando mapa en la nueva ubicación: \(coordinate)")
                        cameraPosition = .camera(
                            MapCamera(centerCoordinate: coordinate, distance: 1000) // Zoom de 2km
                        )
                        getAddressFromLatLon(coor:coordinate)
                    }
                }
                .onChange(of: locationManager.authorizationStatus) { oldValue, newValue in
                    // Cuando cambia el estado del permiso, verificamos si fue denegado.
                    if newValue == .denied || newValue == .restricted {
                        alertMessage = "La aplicación no tiene permiso para acceder a tu ubicación. Por favor, activa los servicios de ubicación en Ajustes para centrar el mapa."
                        showPermissionAlert = true
                    }
                }
                .alert("Permiso de Ubicación Requerido", isPresented: $showPermissionAlert) {
                    // La alerta tiene dos botones:
                    Button("Cancelar", role: .cancel) {}
                    Button("Ajustes") {
                        // Este botón abre la configuración de la app para que el usuario pueda cambiar el permiso.
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                } message: {
                    Text(alertMessage)
                }
                if viewmodel.isDelivery {
                VStack{
                    Button {
                        viewmodel.cancelDelivery()
                        dismiss()
                    } label: {
                        Label("Confirm reception", systemImage: "checkmark.seal.fill")
                            .padding()
                            .foregroundStyle(.yellow)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    Button {
                        viewmodel.confirmDelivery()
                        dismiss()
                    } label: {
                        Label("Cancel order", systemImage: "trash.fill")
                            .padding()
                            .foregroundStyle(.yellow)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    Button {
                        openSomeUrl(s: "https://api.whatsapp.com/send?phone=525621001774&text=Hi.%20I%20need%20help%20with%20my%20order:%20"+viewmodel.deliveryId)
                    } label: {
                        Label("Call support", systemImage: "phone.circle")
                            .padding()
                            .foregroundStyle(.yellow)
                            .background(.black)
                            .cornerRadius(20)
                    }
                }.frame(maxHeight: .infinity, alignment: .bottom)
                }
                if !viewmodel.isDelivery {
                VStack{
                    Button {
                        pMethod="Cash"
                        openSomeUrl(s: "https://api.whatsapp.com/send?phone=525621001774&text=Hi.%20My%20order%20Id%20is:%20"+viewmodel.deliveryId+"%20I%20would%20like%20to%20pay%20with%20"+pMethod)
                        viewmodel.setDelivery()
                    } label: {
                        Label("Cash (Mexican Peso)", systemImage: "dollarsign")
                            .padding()
                            .foregroundStyle(.yellow)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    Button {
                        pMethod="CreditCard"
                        openSomeUrl(s: "https://api.whatsapp.com/send?phone=525621001774&text=Hi.%20My%20order%20Id%20is:%20"+viewmodel.deliveryId+"%20I%20would%20like%20to%20pay%20with%20"+pMethod)
                        viewmodel.setDelivery()
                    } label: {
                        Label("Credit Card (Visa/MasterCard/Amex)", systemImage: "creditcard.viewfinder")
                            .padding()
                            .foregroundStyle(.yellow)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    Button {
                        pMethod="WireTransfer"
                        openSomeUrl(s: "https://api.whatsapp.com/send?phone=525621001774&text=Hi.%20My%20order%20Id%20is:%20"+viewmodel.deliveryId+"%20I%20would%20like%20to%20pay%20with%20"+pMethod)
                        viewmodel.setDelivery()
                    } label: {
                        Label("Wire transfer (SPEI)", systemImage: "iphone.gen2.radiowaves.left.and.right")
                            .padding()
                            .foregroundStyle(.yellow)
                            .background(.black)
                            .cornerRadius(20)
                    }
                    Button {
                        pMethod="Crypto"
                        openSomeUrl(s: "https://api.whatsapp.com/send?phone=525621001774&text=Hi.%20My%20order%20Id%20is:%20"+viewmodel.deliveryId+"%20I%20would%20like%20to%20pay%20with%20"+pMethod)
                        viewmodel.setDelivery()
                    } label: {
                        Label("Crypto (BTC/USDT)", systemImage: "bitcoinsign.arrow.circlepath")
                            .padding()
                            .foregroundStyle(.yellow)
                            .background(.black)
                            .cornerRadius(20)
                    }.padding(.bottom, 15)
                }.frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            Text(viewmodel.isDelivery ? "Your delivery is on its way" : "Send to:  \(adressText)")//.background(Color(.gray))
            Text("Delivery time: ~\(String(viewmodel.timeLeft)) mins")
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                if !viewmodel.isDelivery{
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Back", systemImage: "arrowshape.turn.up.left.fill")
                    }.tint(Color.yellow)
                }
            }
           /* ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: MapView(viewmodel: viewmodel).navigationBarBackButtonHidden(true)) {
                    ConfirmView(vm: viewmodel)
                }
            }*/
        }.toolbarBackground(Color.black.opacity(0.99), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
   }
    
    func openSomeUrl(s: String) {
        guard let url = URL(string: s) else { return }
        UIApplication.shared.open(url)
    }
    
    func getAddressFromLatLon(coor:CLLocationCoordinate2D) {
        coordinateG = coor
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = coor.latitude
        center.longitude = coor.longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [self](placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
            guard let pm = placemarks else {
                //let latSub = String(self.latitude.prefix(7))
                //let longSub = String(self.longitude.prefix(8))
               self.adressText = "No pudimos obtener tu dirección. Habilita los servicios de ubicación o haz click en el botón ayuda para enviarnos tu ubicación por Whatsapp"
                return
           }
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.subThoroughfare != nil {
                    addressString = addressString + pm.subThoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self.adressText = addressString
            }
               
        })
    }
}

/*extension MapView:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        getAddressFromLatLon(coor: center)
       }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView{
           
        }
    }
}*/
