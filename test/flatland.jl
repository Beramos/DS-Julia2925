

@testset "flatland" begin
    import DSJulia.Flatland

    @testset "Rectangle" begin
        rect = Flatland.Rectangle((1, 1), l=2, w=2)
        square = Flatland.Square((2.0, 1), l=2)

        @test Flatland.ncorners(rect) == Flatland.ncorners(square) == 4
        @test Flatland.center(rect) == (1,1) !=  Flatland.center(square)

        @test Flatland.xlim(rect) == (0, 2)
        @test Flatland.ylim(rect) == Flatland.ylim(square) == (0, 2)

        @test Flatland.area(rect) ≈ Flatland.area(square) ≈ 4

        Flatland.move!(square, (-1, 0))
        @test Flatland.xlim(rect) == Flatland.xlim(square)

        @test (0.1, 0.3) ∈ rect
        @test (7, 0.1) ∉ square

        @test rect ∩ Flatland.Rectangle((2, 2), l=2, w=2)
        @test !(rect ∩ Flatland.Rectangle((4, 2), l=2, w=2))
    end
end

