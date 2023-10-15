/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package lib;

import java.util.Random;

/**
 *
 * @author khaye
 */
public class util {
    public int generateRandomCode() {
        Random random = new Random();
        return 100000 + random.nextInt(900000); // This will generate a random 6-digit number
    }
    
}
