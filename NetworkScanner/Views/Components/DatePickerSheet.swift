//
//  DatePickerSheet.swift
//  NetworkScanner
//
//  Created by Danil Kazakov on 2025/11/29.
//

import SwiftUI

// MARK: - Date Picker Sheet

struct DatePickerSheet: View {
    
    // MARK: - Properties
    
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    let onApply: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(Constants.Labels.selectDate)
                .font(.headline)
                .padding(.top)
            
            DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()
            
            Button {
                onApply()
                isPresented = false
            } label: {
                Text(Constants.Actions.apply)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .presentationDetents()
    }
}

#Preview {
    DatePickerSheet(
        selectedDate: .constant(Date()),
        isPresented: .constant(true)
    ) {
        // Apply action
    }
}
