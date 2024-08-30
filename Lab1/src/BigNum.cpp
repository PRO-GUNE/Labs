#include <iostream>
#include <vector>
#include <algorithm>
#include <stdexcept>
#include <cmath>
#include "BigNum.h"

// Helper function to remove leading zeros
void BigNum::removeLeadingZeros()
{
    while (digits.size() > 1 && digits.back() == 0)
    {
        digits.pop_back();
    }
}

// Helper function to add two BigNum numbers
BigNum BigNum::add(const BigNum &other) const
{
    if (negative == other.negative)
    {
        BigNum result;
        result.digits.resize(std::max(digits.size(), other.digits.size()) + 1, 0);
        result.negative = negative;

        int carry = 0;
        for (size_t i = 0; i < result.digits.size(); ++i)
        {
            int sum = carry;
            if (i < digits.size())
                sum += digits[i];
            if (i < other.digits.size())
                sum += other.digits[i];

            carry = sum / 10;
            result.digits[i] = sum % 10;
        }

        result.removeLeadingZeros();
        return result;
    }
    else
    {
        return *this - (-other);
    }
}

// Helper function to subtract two BigNum numbers
BigNum BigNum::subtract(const BigNum &other) const
{
    if (negative == other.negative)
    {
        if (abs() >= other.abs())
        {
            BigNum result = *this;
            int borrow = 0;
            for (size_t i = 0; i < other.digits.size() || borrow; ++i)
            {
                result.digits[i] -= (i < other.digits.size() ? other.digits[i] : 0) + borrow;
                borrow = result.digits[i] < 0;
                if (borrow)
                    result.digits[i] += 10;
            }

            result.removeLeadingZeros();
            return result;
        }
        else
        {
            return -(other - *this);
        }
    }
    else
    {
        return *this + (-other);
    }
}

// Helper function to multiply two BigNum numbers
BigNum BigNum::multiply(const BigNum &other) const
{
    BigNum result;
    result.digits.resize(digits.size() + other.digits.size(), 0);
    result.negative = negative != other.negative;

    for (size_t i = 0; i < digits.size(); ++i)
    {
        int carry = 0;
        for (size_t j = 0; j < other.digits.size() || carry; ++j)
        {
            long long cur = result.digits[i + j] +
                            digits[i] * 1LL * (j < other.digits.size() ? other.digits[j] : 0) +
                            carry;
            result.digits[i + j] = cur % 10;
            carry = cur / 10;
        }
    }

    result.removeLeadingZeros();
    return result;
}

// Helper function for division; returns quotient and remainder
std::pair<BigNum, BigNum> BigNum::divide(const BigNum &other) const
{
    if (other == 0)
        throw std::invalid_argument("Division by zero");

    BigNum result, remainder;
    result.digits.resize(digits.size(), 0);
    result.negative = negative != other.negative;
    remainder.negative = negative;

    for (int i = digits.size() - 1; i >= 0; --i)
    {
        remainder.digits.insert(remainder.digits.begin(), digits[i]);
        remainder.removeLeadingZeros();

        int quotientDigit = 0;
        int left = 0, right = 10;
        while (left <= right)
        {
            int mid = (left + right) / 2;
            BigNum candidate = other.abs() * BigNum(mid);
            if (candidate <= remainder.abs())
            {
                quotientDigit = mid;
                left = mid + 1;
            }
            else
            {
                right = mid - 1;
            }
        }

        result.digits[i] = quotientDigit;
        remainder = remainder.abs() - (other.abs() * BigNum(quotientDigit));
    }

    result.removeLeadingZeros();
    remainder.removeLeadingZeros();
    return {result, remainder};
}

BigNum getModulus(const int mod_bit_length)
{
    BigNum mod = BigNum(1LL);
    for (size_t i = 0; i < mod_bit_length; i++)
        mod = mod * 2;

    return mod;
}

// Constructors
BigNum::BigNum() : digits(1, 0), negative(false) {}
BigNum::BigNum(long long num) : negative(num < 0)
{
    if (negative)
        num = -num;
    do
    {
        digits.push_back(num % 10);
        num /= 10;
    } while (num > 0);
}

BigNum::BigNum(const std::string &numStr)
{
    // Initialize with zero
    digits = {0};
    negative = false;

    if (numStr.empty())
    {
        return; // If empty string, initialize to zero
    }

    size_t start = 0; // Start position for reading digits

    // Check for sign
    if (numStr[0] == '-')
    {
        negative = true;
        start = 1; // Start after the negative sign
    }
    else if (numStr[0] == '+')
    {
        start = 1; // Start after the positive sign
    }

    // Read the string in reverse order to fill digits
    digits.clear();
    for (size_t i = numStr.length(); i > start; --i)
    {
        if (std::isdigit(numStr[i - 1]))
        {
            digits.push_back(numStr[i - 1] - '0');
        }
        else
        {
            throw std::invalid_argument("Invalid character in input string");
        }
    }

    removeLeadingZeros();
}

// Overloading operators
BigNum BigNum::operator+(const BigNum &other) const { return add(other); }
BigNum BigNum::operator-(const BigNum &other) const { return subtract(other); }
BigNum BigNum::operator*(const BigNum &other) const { return multiply(other); }
BigNum BigNum::operator/(const BigNum &other) const { return divide(other).first; }
BigNum BigNum::operator%(const BigNum &other) const { return divide(other).second; }

bool BigNum::operator==(const BigNum &other) const
{
    return digits == other.digits && negative == other.negative;
}

bool BigNum::operator!=(const BigNum &other) const { return !(*this == other); }

bool BigNum::operator<(const BigNum &other) const
{
    if (negative != other.negative)
        return negative;

    if (digits.size() != other.digits.size())
    {
        return negative ? digits.size() > other.digits.size() : digits.size() < other.digits.size();
    }

    for (int i = digits.size() - 1; i >= 0; --i)
    {
        if (digits[i] != other.digits[i])
        {
            return negative ? digits[i] > other.digits[i] : digits[i] < other.digits[i];
        }
    }

    return false;
}

bool BigNum::operator>(const BigNum &other) const { return other < *this; }
bool BigNum::operator<=(const BigNum &other) const { return !(other < *this); }
bool BigNum::operator>=(const BigNum &other) const { return !(*this < other); }

BigNum BigNum::operator-() const
{
    BigNum result = *this;
    if (*this != 0)
        result.negative = !negative;
    return result;
}

BigNum BigNum::operator=(const BigNum &other)
{
    negative = other.negative;
    if (this != &other)
    {
        digits = other.digits;
    }

    return *this;
}

BigNum::BigNum(const BigNum &other)
{
    negative = other.negative;
    digits = other.digits;
}

BigNum BigNum::abs() const
{
    BigNum result = *this;
    result.negative = false;
    return result;
}

// Function to perform modular addition
BigNum modAdd(const BigNum &a, const BigNum &b, int mod_bit_length)
{
    BigNum mod = getModulus(mod_bit_length);
    return (a + b) % mod;
}

// Function to perform modular multiplication
BigNum modMultiply(const BigNum &a, const BigNum &b, int mod_bit_length)
{
    BigNum mod = getModulus(mod_bit_length);
    return (a * b) % mod;
}

// Function to perform modular inversion using Extended Euclidean Algorithm
BigNum modInverse(const BigNum &a, int mod_bit_length)
{
    BigNum mod = getModulus(mod_bit_length);
    BigNum m0 = mod, t, q;
    BigNum x0 = 0, x1 = 1;

    if (mod == 1)
        return 0;

    BigNum a1 = a.abs();
    BigNum modulus = mod.abs();
    while (modulus != 0)
    {
        if (modulus == 0)
            throw std::invalid_argument("Modular inverse does not exist");
        q = a1 / modulus;
        t = modulus;

        modulus = a1 % modulus;
        a1 = t;

        t = x0;
        x0 = x1 - q * x0;
        x1 = t;
    }

    if (x1 < 0)
        x1 = x1 + m0;

    return x1;
}
