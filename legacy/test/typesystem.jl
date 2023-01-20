@testset "type system" begin
    using DSJulia.Solutions
    @test Solutions.bunchofnumbers_parser("4, 5.5, 8\n") ≈ 4 + 5.5 + 8

    @testset "Wizarding currency" begin
        
        @test Solutions.WizCur(1, 1, 1) == Solutions.WizCur(0, 17, 30)
        @test Solutions.galleons(Solutions.WizCur(0, 17, 0)) == 1
        @test Solutions.knuts(Solutions.WizCur(0, 17, 78)) == 78 % 29
        @test Solutions.moneyinknuts(Solutions.WizCur(1, 1, 1)) == 1 + 29 + 17 * 29
        @test Solutions.WizCur(1, 1, 1) + Solutions.WizCur(0, 17, 30) == Solutions.WizCur(2, 2, 2)
    end

    @testset "Vandermonde" begin
        using LinearAlgebra
        α = [1, 2, 3, 4]
        V = Solutions.Vandermonde(α, 4)
        @test V == [ones(Int, 4) α α.^2 α.^3 ]
        @test det(V) == det([ones(Int, 4) α α.^2 α.^3 ])
    end
end
