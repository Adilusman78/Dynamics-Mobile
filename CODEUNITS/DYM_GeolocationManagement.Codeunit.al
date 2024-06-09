codeunit 70124 DYM_GeolocationManagement
{
    #region Math
    procedure Sin(x: Decimal): Decimal
    begin
        exit(x - Power(x, 3) / 6 + Power(x, 5) / 120 - Power(x, 7) / 5040);
    end;

    procedure Cos(x: Decimal) Cos: Decimal
    begin
        exit(Sin(x + Pi / 2));
    end;

    procedure ArcTan(x: Decimal): Decimal
    begin
        exit(x - Power(x, 3) / 3 + Power(x, 5) / 5 - Power(x, 7) / 7);
    end;

    procedure ArcTan2(y: Decimal; x: Decimal): Decimal
    begin
        if (x > 0) then exit(ArcTan(y / x));
        if ((x < 0) and (y >= 0)) then exit(ArcTan(y / x) + Pi);
        if ((x < 0) and (y < 0)) then exit(ArcTan(y / x) - Pi);
        if ((x = 0) and (y < 0)) then exit(-Pi / 2);
        if ((x = 0) and (y > 0)) then exit(Pi / 2);
    end;

    procedure Pi(): Decimal
    begin
        exit(3.14159265358979323);
    end;

    procedure Sqrt(x: Decimal): Decimal
    begin
        exit(Power(x, 0.5));
    end;
    #endregion 
    #region Geo
    procedure CalcDistance(Lat1: Decimal; Long1: Decimal; Lat2: Decimal; Long2: Decimal) Result: Decimal
    var
        R: Decimal;
        a: Decimal;
        b: Decimal;
        c: Decimal;
    begin
        Clear(Result);
        R := 6371000;
        a := Power(Sin(Abs(Lat1 * 2 * Pi / 90 - Lat2 * 2 * Pi / 90) / 2), 2);
        b := Power(Sin(Abs(Long1 * 2 * Pi / 90 - Long2 * 2 * Pi / 90) / 2), 2);
        a := a + Cos(Lat1 * Pi / 90) * Cos(Lat2 * Pi / 90) * b;
        c := 2 * ArcTan2(Sqrt(a), Sqrt(1 - a));
        Result := R * c;
    end;
    #endregion
}
