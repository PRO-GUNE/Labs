// BigNum.h
#ifndef BIGNUM_H
#define BIGNUM_H

#include <iostream>
#include <vector>
#include <utility>

class BigNum
{
private:
    std::vector<int> digits; // Store digits in reverse order for easier arithmetic
    bool negative;           // Sign of the number

    // Helper function to remove leading zeros
    void removeLeadingZeros();

    // Helper function to add two BigNum numbers
    BigNum add(const BigNum &other) const;

    // Helper function to subtract two BigNum numbers
    BigNum subtract(const BigNum &other) const;

    // Helper function to multiply two BigNum numbers
    BigNum multiply(const BigNum &other) const;

    // Helper function for division; returns quotient and remainder
    std::pair<BigNum, BigNum> divide(const BigNum &other) const;

    // Helper function to get modulus of a BigNum
    BigNum getModulus(const int mod_bit_length);

public:
    // Constructors
    BigNum();                          // Default constructor
    BigNum(long long num);             // Constructor from long long integer
    BigNum(const std::string &numStr); // Constructor from string

    // Overloading operators
    BigNum operator+(const BigNum &other) const;
    BigNum operator-(const BigNum &other) const;
    BigNum operator*(const BigNum &other) const;
    BigNum operator/(const BigNum &other) const;
    BigNum operator%(const BigNum &other) const;

    bool operator==(const BigNum &other) const;
    bool operator!=(const BigNum &other) const;
    bool operator<(const BigNum &other) const;
    bool operator>(const BigNum &other) const;
    bool operator<=(const BigNum &other) const;
    bool operator>=(const BigNum &other) const;
    BigNum operator=(const BigNum &other);

    BigNum(const BigNum &other);

    BigNum operator-() const;

    BigNum abs() const;

    // Friend function for output stream overloading
    friend std::ostream &operator<<(std::ostream &os, const BigNum &num)
    {
        if (num.negative)
            os << '-';
        for (int i = num.digits.size() - 1; i >= 0; --i)
        {
            os << num.digits[i];
        }
        return os;
    }
};

// Function declarations for modular arithmetic
BigNum modAdd(const BigNum &a, const BigNum &b, int mod_length);
BigNum modMultiply(const BigNum &a, const BigNum &b, int mod_length);
BigNum modInverse(const BigNum &a, int mod_length);

#endif // BIGNUM_H
