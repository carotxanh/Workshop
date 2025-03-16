package com.mycompany.ticketplane.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * Đối tượng Location đại diện cho địa điểm (điểm khởi hành hoặc điểm đến)
 */
@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Location {
    private String locationId;
    private String name;
    private String city;
    private String country;
    private String airportCode;
    private String description;
    
    @Override
    public String toString() {
        return name + " (" + city + ")";
    }
}