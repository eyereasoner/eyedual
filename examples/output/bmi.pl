weightKg(case, 72.0).
heightM(case, 1.78).
units(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters.").
heightSquared(case, 3.1684000000000001).
bmi(case, 22.724403484408533).
bmi(answer, 22.72).
bmiRoundedInt(case, 2272).
healthyMinKg(case, 58.615400000000001).
healthyMinKg(answer, 58.6).
healthyMaxKg(case, 78.893159999999995).
healthyMaxKg(answer, 78.9).
healthyMinKgRoundedInt(case, 586).
healthyMaxKgRoundedInt(case, 789).
category(decision, "Normal").
category(answer, "Normal").
heightCm(answer, 178).
heightCm(report, 178).
formula(reason, "BMI is defined as weight in kilograms divided by height in meters squared.").
calculation(reason, "The normalized weight and height were used to compute BMI, then the result was mapped to the WHO adult category table.").
categoryRule(reason, "Normal").
unitsExplanation(reason, "Inputs were already metric, so kilograms stay kilograms and centimeters are divided by 100 to obtain meters.").
c1(check, "OK - the input was normalized into positive SI values.").
c2(check, "OK - height squared was reconstructed from the normalized height.").
c3(check, "OK - the BMI value matches the BMI = kg / m² formula.").
c4(check, "OK - a BMI of 18.49 stays below the normal-weight threshold.").
c5(check, "OK - the lower boundary is half-open: BMI 18.5 is classified as Normal.").
c6(check, "OK - BMI 25.0 starts the Overweight category.").
c7(check, "OK - BMI 30.0 starts the Obesity I category.").
c8(check, "OK - classification behavior is monotonic across representative BMI values.").
c9(check, "OK - the healthy-weight band was reconstructed from BMI 18.5 to 24.9 at the same height.").
result(report, bmi(22.72, "Normal")).
healthyWeightRangeKg(report, range(58.6, 78.9)).
checkPassed(report, c1).
checkPassed(report, c2).
checkPassed(report, c3).
checkPassed(report, c4).
checkPassed(report, c5).
checkPassed(report, c6).
checkPassed(report, c7).
checkPassed(report, c8).
checkPassed(report, c9).
