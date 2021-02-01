

@testset "flatland" begin
    import DSJulia.Flatland

    @testset "rectangle" begin
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

    @testset "circle" begin
        circle = Flatland.Circle((1, 1), R=1)

        @test Flatland.ncorners(circle) == 0
        @test Flatland.center(circle) == (1, 1)

        @test Flatland.xlim(circle) == (0, 2)
        @test Flatland.ylim(circle) == (0, 2)

        @test Flatland.area(circle) ≈ π

        @test (0.5, 0.5) ∈ circle
        @test (7, 0.1) ∉ circle

        @test circle ∩ Flatland.Circle((2, 2), R=0.5)
        @test !(circle ∩ Flatland.Circle((5, 3), R=0.5))
    end

    @testset "pregular polygons" begin
        pent = Flatland.RegularPolygon((1, 1), 5, R=1)

        @test Flatland.ncorners(pent) == 5
        @test Flatland.center(pent) == (1, 1)

        @test Flatland.xlim(pent)[1] ≥ 0
        @test Flatland.ylim(pent)[1] ≥ 0

        @test Flatland.xlim(pent)[2] ≤ 2
        @test Flatland.ylim(pent)[2] ≤ 2

        @test Flatland.area(Flatland.RegularPolygon((1, 1), 1000_000, R=1)) ≈ π 

        @test (0.5, 0.5) ∈ pent
        @test (7, 0.1) ∉ pent

        @test pent ∩ Flatland.RegularPolygon((2, 2), 5, R=1)
        @test !(pent ∩ Flatland.RegularPolygon((8, 1), 5, R=1/2))
end


    @testset "triangle" begin
        triangle = Flatland.Triangle((0, 0), (1, 0), (0.5, 0.5))

        @test Flatland.ncorners(triangle) == 3
        @test all(Flatland.center(triangle) .≈ (0.5, 0.5/3))

        @test all(Flatland.xlim(triangle) .≈ (0, 1))
        @test all(Flatland.ylim(triangle) .≈ (0, 0.5))

        @test Flatland.area(triangle) ≈ 0.25

        @test (0.5, 0.3) ∈ triangle
        @test (0.1, 0.2) ∉ triangle

        @test triangle ∩ Flatland.Triangle((0.25, 0.25), (0.5, 1.5), (1.5, 1.5))
        @test !(triangle ∩ Flatland.Triangle((3, 4), (2, 2), (1.5, 1.5)))
    end
end

