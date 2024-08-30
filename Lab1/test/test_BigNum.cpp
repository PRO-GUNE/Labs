#include <iostream>
#include <cassert>
#include "BigNum.h"

// Define large numbers for testing
BigNum num_1 = BigNum("340282366920938463463374607431768211457");
BigNum num_2 = BigNum("340282366920938463463374607431768211456");
BigNum num_3 = BigNum("1152921504606846976");
BigNum num_4 = BigNum("1152921504606846975");

// Helper function to display test results
void assertEqual(const BigNum &a, const BigNum &b, const std::string &testName)
{
    if (a == b)
        std::cout << testName << " passed." << std::endl;
    else
        std::cout << testName << " failed. Expected " << b << " but got " << a << "." << std::endl;
}

// Test addition
void test_addition()
{
    assertEqual(num_1 + num_2, BigNum("680564733841876926926749214863536422913"), "Addition Test 1");
    assertEqual(num_1 + num_3, BigNum("340282366920938463464527528936375058433"), "Addition Test 2");
    assertEqual(num_3 + num_4, BigNum("2305843009213693951"), "Addition Test 3");
}

// Test subtraction
void test_subtraction()
{
    assertEqual(num_1 - num_2, BigNum("1"), "Subtraction Test 4");
    assertEqual(num_1 - num_3, BigNum("340282366920938463462221685927161364481"), "Subtraction Test 5");
    assertEqual(num_3 - num_4, BigNum("1"), "Subtraction Test 6");
}

// Test multiplication
void test_multiplication()
{
    assertEqual(num_1 * num_2, BigNum("115792089237316195423570985008687907853610267032561502502920958615344897851392"), "Multiplication Test 7");
    assertEqual(num_1 * num_3, BigNum("392318858461667547739736838950479151007550136783609004032"), "Multiplication Test 8");
    assertEqual(num_3 * num_4, BigNum("1329227995784915871750885555673497600"), "Multiplication Test 9");
}

// Test division
void test_division()
{
    assertEqual(num_3 / num_1, BigNum("0"), "Division Test 10");
    assertEqual(num_1 / num_2, BigNum("1"), "Division Test 11");
    assertEqual(num_3 / num_4, BigNum("1"), "Division Test 12");
}

// Test modulus
void test_modulus()
{
    assertEqual(num_3 % num_1, BigNum("1152921504606846976") % num_1, "Modulus Test 13");
    assertEqual(num_3 % num_4, BigNum("1"), "Modulus Test 14");
}

// Test modular arithmetic
void test_modular_arithmetic()
{
    assertEqual(modAdd(num_3, num_4, 128), BigNum("2305843009213693951"), "Modular Addition Test 15");
    assertEqual(modAdd(num_3, num_4, 256), BigNum("2305843009213693951"), "Modular Addition Test 16");
    assertEqual(modMultiply(num_3, num_4, 128), BigNum("1329227995784915871750885555673497600"), "Modular Multiplication Test 17");
    assertEqual(modMultiply(num_1, num_2, 256), BigNum("340282366920938463463374607431768211456"), "Modular Multiplication Test 18");

    // Modular Inversion Tests
    try
    {
        assertEqual(modInverse(num_4, 128), BigNum("338953138925153547589317878866881019903"), "Modular Inversion Test 19");
    }
    catch (const std::exception &e)
    {
        std::cout << "Modular Inversion Test 19 failed: " << e.what() << std::endl;
    }

    try
    {
        assertEqual(modInverse(num_4, 256), BigNum("115790322390251417039239869215646299045894469606720753195441786934024766226431"), "Modular Inversion Test 20");
    }
    catch (const std::exception &e)
    {
        std::cout << "Modular Inversion Test 20 failed: " << e.what() << std::endl;
    }
}

int main()
{
    std::cout << "Running tests..." << std::endl;
    std::cout << "--------------------------" << std::endl;

    std::cout << "Running addition tests..." << std::endl;
    test_addition();
    std::cout << "--------------------------" << std::endl;

    std::cout << "Running subtraction tests..." << std::endl;
    test_subtraction();
    std::cout << "--------------------------" << std::endl;

    std::cout << "Running multiplication tests..." << std::endl;
    test_multiplication();
    std::cout << "--------------------------" << std::endl;

    std::cout << "Running division tests..." << std::endl;
    test_division();
    std::cout << "--------------------------" << std::endl;

    std::cout << "Running modulus tests..." << std::endl;
    test_modulus();
    std::cout << "--------------------------" << std::endl;

    std::cout << "Running modular arithmetic tests..." << std::endl;
    test_modular_arithmetic();
    std::cout << "--------------------------" << std::endl;

    return 0;
}
