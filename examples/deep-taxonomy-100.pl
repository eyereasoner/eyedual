% =============================================================================================================================
% Deep Taxonomy - depth 100 - expanded N3-style eyeprolog
%
% Adjacent rules mirror the Eyeling N3 deep-taxonomy chain. Each step derives
% the next taxonomy class together with two side labels.
% =============================================================================================================================

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: holds_result(X0, X1)

%% goal: answer(X0, X1)

%% goal: reason(X0, X1)

%% goal: result(X0, X1)

%% goal: checkPassed(X0, X1)

%% goal: arc(X0, X1)


:- discontiguous(a/2).

% Program structure: facts set up the scenario, and rules derive the queried conclusions.
% fact

a(ind, n0).

% terminal rule

% Derivation rules: each rule below contributes one logical step toward the displayed results.
holds_result(test, true) :- once(a(ind, a2)).
a(X, a2) :- a(X, n100).

% Adjacent N3-style taxonomy rules.

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
a(X, n2) :- a(X, n1).
a(X, i2) :- a(X, n1).
a(X, j2) :- a(X, n1).
a(X, n3) :- a(X, n2).
a(X, i3) :- a(X, n2).
a(X, j3) :- a(X, n2).
a(X, n4) :- a(X, n3).
a(X, i4) :- a(X, n3).
a(X, j4) :- a(X, n3).
a(X, n5) :- a(X, n4).
a(X, i5) :- a(X, n4).
a(X, j5) :- a(X, n4).
a(X, n6) :- a(X, n5).
a(X, i6) :- a(X, n5).
a(X, j6) :- a(X, n5).
a(X, n7) :- a(X, n6).
a(X, i7) :- a(X, n6).
a(X, j7) :- a(X, n6).
a(X, n8) :- a(X, n7).
a(X, i8) :- a(X, n7).
a(X, j8) :- a(X, n7).
a(X, n9) :- a(X, n8).
a(X, i9) :- a(X, n8).
a(X, j9) :- a(X, n8).
a(X, n10) :- a(X, n9).
a(X, i10) :- a(X, n9).
a(X, j10) :- a(X, n9).
a(X, n11) :- a(X, n10).
a(X, i11) :- a(X, n10).
a(X, j11) :- a(X, n10).
a(X, n12) :- a(X, n11).
a(X, i12) :- a(X, n11).
a(X, j12) :- a(X, n11).
a(X, n13) :- a(X, n12).
a(X, i13) :- a(X, n12).
a(X, j13) :- a(X, n12).
a(X, n14) :- a(X, n13).
a(X, i14) :- a(X, n13).
a(X, j14) :- a(X, n13).
a(X, n15) :- a(X, n14).
a(X, i15) :- a(X, n14).
a(X, j15) :- a(X, n14).
a(X, n16) :- a(X, n15).
a(X, i16) :- a(X, n15).
a(X, j16) :- a(X, n15).
a(X, n17) :- a(X, n16).
a(X, i17) :- a(X, n16).
a(X, j17) :- a(X, n16).
a(X, n18) :- a(X, n17).
a(X, i18) :- a(X, n17).
a(X, j18) :- a(X, n17).
a(X, n19) :- a(X, n18).
a(X, i19) :- a(X, n18).
a(X, j19) :- a(X, n18).
a(X, n20) :- a(X, n19).
a(X, i20) :- a(X, n19).
a(X, j20) :- a(X, n19).
a(X, n21) :- a(X, n20).
a(X, i21) :- a(X, n20).
a(X, j21) :- a(X, n20).
a(X, n22) :- a(X, n21).
a(X, i22) :- a(X, n21).
a(X, j22) :- a(X, n21).
a(X, n23) :- a(X, n22).
a(X, i23) :- a(X, n22).
a(X, j23) :- a(X, n22).
a(X, n24) :- a(X, n23).
a(X, i24) :- a(X, n23).
a(X, j24) :- a(X, n23).
a(X, n25) :- a(X, n24).
a(X, i25) :- a(X, n24).
a(X, j25) :- a(X, n24).
a(X, n26) :- a(X, n25).
a(X, i26) :- a(X, n25).
a(X, j26) :- a(X, n25).
a(X, n27) :- a(X, n26).
a(X, i27) :- a(X, n26).
a(X, j27) :- a(X, n26).
a(X, n28) :- a(X, n27).
a(X, i28) :- a(X, n27).
a(X, j28) :- a(X, n27).
a(X, n29) :- a(X, n28).
a(X, i29) :- a(X, n28).
a(X, j29) :- a(X, n28).
a(X, n30) :- a(X, n29).
a(X, i30) :- a(X, n29).
a(X, j30) :- a(X, n29).
a(X, n31) :- a(X, n30).
a(X, i31) :- a(X, n30).
a(X, j31) :- a(X, n30).
a(X, n32) :- a(X, n31).
a(X, i32) :- a(X, n31).
a(X, j32) :- a(X, n31).
a(X, n33) :- a(X, n32).
a(X, i33) :- a(X, n32).
a(X, j33) :- a(X, n32).
a(X, n34) :- a(X, n33).
a(X, i34) :- a(X, n33).
a(X, j34) :- a(X, n33).
a(X, n35) :- a(X, n34).
a(X, i35) :- a(X, n34).
a(X, j35) :- a(X, n34).
a(X, n36) :- a(X, n35).
a(X, i36) :- a(X, n35).
a(X, j36) :- a(X, n35).
a(X, n37) :- a(X, n36).
a(X, i37) :- a(X, n36).
a(X, j37) :- a(X, n36).
a(X, n38) :- a(X, n37).
a(X, i38) :- a(X, n37).
a(X, j38) :- a(X, n37).
a(X, n39) :- a(X, n38).
a(X, i39) :- a(X, n38).
a(X, j39) :- a(X, n38).
a(X, n40) :- a(X, n39).
a(X, i40) :- a(X, n39).
a(X, j40) :- a(X, n39).
a(X, n41) :- a(X, n40).
a(X, i41) :- a(X, n40).
a(X, j41) :- a(X, n40).
a(X, n42) :- a(X, n41).
a(X, i42) :- a(X, n41).
a(X, j42) :- a(X, n41).
a(X, n43) :- a(X, n42).
a(X, i43) :- a(X, n42).
a(X, j43) :- a(X, n42).
a(X, n44) :- a(X, n43).
a(X, i44) :- a(X, n43).
a(X, j44) :- a(X, n43).
a(X, n45) :- a(X, n44).
a(X, i45) :- a(X, n44).
a(X, j45) :- a(X, n44).
a(X, n46) :- a(X, n45).
a(X, i46) :- a(X, n45).
a(X, j46) :- a(X, n45).
a(X, n47) :- a(X, n46).
a(X, i47) :- a(X, n46).
a(X, j47) :- a(X, n46).
a(X, n48) :- a(X, n47).
a(X, i48) :- a(X, n47).
a(X, j48) :- a(X, n47).
a(X, n49) :- a(X, n48).
a(X, i49) :- a(X, n48).
a(X, j49) :- a(X, n48).
a(X, n50) :- a(X, n49).
a(X, i50) :- a(X, n49).
a(X, j50) :- a(X, n49).
a(X, n51) :- a(X, n50).
a(X, i51) :- a(X, n50).
a(X, j51) :- a(X, n50).
a(X, n52) :- a(X, n51).
a(X, i52) :- a(X, n51).
a(X, j52) :- a(X, n51).
a(X, n53) :- a(X, n52).
a(X, i53) :- a(X, n52).
a(X, j53) :- a(X, n52).
a(X, n54) :- a(X, n53).
a(X, i54) :- a(X, n53).
a(X, j54) :- a(X, n53).
a(X, n55) :- a(X, n54).
a(X, i55) :- a(X, n54).
a(X, j55) :- a(X, n54).
a(X, n56) :- a(X, n55).
a(X, i56) :- a(X, n55).
a(X, j56) :- a(X, n55).
a(X, n57) :- a(X, n56).
a(X, i57) :- a(X, n56).
a(X, j57) :- a(X, n56).
a(X, n58) :- a(X, n57).
a(X, i58) :- a(X, n57).
a(X, j58) :- a(X, n57).
a(X, n59) :- a(X, n58).
a(X, i59) :- a(X, n58).
a(X, j59) :- a(X, n58).
a(X, n60) :- a(X, n59).
a(X, i60) :- a(X, n59).
a(X, j60) :- a(X, n59).
a(X, n61) :- a(X, n60).
a(X, i61) :- a(X, n60).
a(X, j61) :- a(X, n60).
a(X, n62) :- a(X, n61).
a(X, i62) :- a(X, n61).
a(X, j62) :- a(X, n61).
a(X, n63) :- a(X, n62).
a(X, i63) :- a(X, n62).
a(X, j63) :- a(X, n62).
a(X, n64) :- a(X, n63).
a(X, i64) :- a(X, n63).
a(X, j64) :- a(X, n63).
a(X, n65) :- a(X, n64).
a(X, i65) :- a(X, n64).
a(X, j65) :- a(X, n64).
a(X, n66) :- a(X, n65).
a(X, i66) :- a(X, n65).
a(X, j66) :- a(X, n65).
a(X, n67) :- a(X, n66).
a(X, i67) :- a(X, n66).
a(X, j67) :- a(X, n66).
a(X, n68) :- a(X, n67).
a(X, i68) :- a(X, n67).
a(X, j68) :- a(X, n67).
a(X, n69) :- a(X, n68).
a(X, i69) :- a(X, n68).
a(X, j69) :- a(X, n68).
a(X, n70) :- a(X, n69).
a(X, i70) :- a(X, n69).
a(X, j70) :- a(X, n69).
a(X, n71) :- a(X, n70).
a(X, i71) :- a(X, n70).
a(X, j71) :- a(X, n70).
a(X, n72) :- a(X, n71).
a(X, i72) :- a(X, n71).
a(X, j72) :- a(X, n71).
a(X, n73) :- a(X, n72).
a(X, i73) :- a(X, n72).
a(X, j73) :- a(X, n72).
a(X, n74) :- a(X, n73).
a(X, i74) :- a(X, n73).
a(X, j74) :- a(X, n73).
a(X, n75) :- a(X, n74).
a(X, i75) :- a(X, n74).
a(X, j75) :- a(X, n74).
a(X, n76) :- a(X, n75).
a(X, i76) :- a(X, n75).
a(X, j76) :- a(X, n75).
a(X, n77) :- a(X, n76).
a(X, i77) :- a(X, n76).
a(X, j77) :- a(X, n76).
a(X, n78) :- a(X, n77).
a(X, i78) :- a(X, n77).
a(X, j78) :- a(X, n77).
a(X, n79) :- a(X, n78).
a(X, i79) :- a(X, n78).
a(X, j79) :- a(X, n78).
a(X, n80) :- a(X, n79).
a(X, i80) :- a(X, n79).
a(X, j80) :- a(X, n79).
a(X, n81) :- a(X, n80).
a(X, i81) :- a(X, n80).
a(X, j81) :- a(X, n80).
a(X, n82) :- a(X, n81).
a(X, i82) :- a(X, n81).
a(X, j82) :- a(X, n81).
a(X, n83) :- a(X, n82).
a(X, i83) :- a(X, n82).
a(X, j83) :- a(X, n82).
a(X, n84) :- a(X, n83).
a(X, i84) :- a(X, n83).
a(X, j84) :- a(X, n83).
a(X, n85) :- a(X, n84).
a(X, i85) :- a(X, n84).
a(X, j85) :- a(X, n84).
a(X, n86) :- a(X, n85).
a(X, i86) :- a(X, n85).
a(X, j86) :- a(X, n85).
a(X, n87) :- a(X, n86).
a(X, i87) :- a(X, n86).
a(X, j87) :- a(X, n86).
a(X, n88) :- a(X, n87).
a(X, i88) :- a(X, n87).
a(X, j88) :- a(X, n87).
a(X, n89) :- a(X, n88).
a(X, i89) :- a(X, n88).
a(X, j89) :- a(X, n88).
a(X, n90) :- a(X, n89).
a(X, i90) :- a(X, n89).
a(X, j90) :- a(X, n89).
a(X, n91) :- a(X, n90).
a(X, i91) :- a(X, n90).
a(X, j91) :- a(X, n90).
a(X, n92) :- a(X, n91).
a(X, i92) :- a(X, n91).
a(X, j92) :- a(X, n91).
a(X, n93) :- a(X, n92).
a(X, i93) :- a(X, n92).
a(X, j93) :- a(X, n92).
a(X, n94) :- a(X, n93).
a(X, i94) :- a(X, n93).
a(X, j94) :- a(X, n93).
a(X, n95) :- a(X, n94).
a(X, i95) :- a(X, n94).
a(X, j95) :- a(X, n94).
a(X, n96) :- a(X, n95).
a(X, i96) :- a(X, n95).
a(X, j96) :- a(X, n95).
a(X, n97) :- a(X, n96).
a(X, i97) :- a(X, n96).
a(X, j97) :- a(X, n96).
a(X, n98) :- a(X, n97).
a(X, i98) :- a(X, n97).
a(X, j98) :- a(X, n97).
a(X, n99) :- a(X, n98).
a(X, i99) :- a(X, n98).
a(X, j99) :- a(X, n98).
a(X, n100) :- a(X, n99).
a(X, i100) :- a(X, n99).
a(X, j100) :- a(X, n99).

% ARC checks

arc(check1, "C1 OK - the starting classification n0 is present.") :-
 once(a(ind, n0)).

arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.") :-
 once(a(ind, n1)),
 once(a(ind, i1)),
 once(a(ind, j1)).

arc(check3, "C3 OK - the chain reaches the midpoint n50 and still carries both side-label branches.") :-
 once(a(ind, n50)),
 once(a(ind, i50)),
 once(a(ind, j50)).

arc(check4, "C4 OK - the final taxonomy step from n99 to n100 was completed.") :-
 once(a(ind, n99)),
 once(a(ind, n100)).

arc(check5, "C5 OK - once n100 is reached, the terminal class a2 is derived.") :-
 once(a(ind, n100)),
 once(a(ind, a2)).

arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.") :-
 once(a(ind, a2)),
 once(holds_result(test, true)).

% ARC report

answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n100 and then as a2.") :-
 once(holds_result(test, true)).

reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-100 chain: each rule advances one taxonomy level and adds the matching side labels.") :-
 once(a(ind, a2)),
 once(holds_result(test, true)).

checkPassed(report, Check) :-
 arc(Check, _message).

result(report, success) :-
 once(holds_result(test, true)),
 once(arc(check1, _c1)),
 once(arc(check2, _c2)),
 once(arc(check3, _c3)),
 once(arc(check4, _c4)),
 once(arc(check5, _c5)),
 once(arc(check6, _c6)).
