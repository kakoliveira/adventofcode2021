defmodule BoardTest do
  use ExUnit.Case, async: true

  @board_example %Board{
    board: [
      [
        %Number{number: "14", marked: false},
        %Number{number: "21", marked: false},
        %Number{number: "17", marked: false},
        %Number{number: "24", marked: false},
        %Number{number: "4", marked: false}
      ],
      [
        %Number{number: "10", marked: false},
        %Number{number: "16", marked: false},
        %Number{number: "15", marked: false},
        %Number{number: "9", marked: false},
        %Number{number: "19", marked: false}
      ],
      [
        %Number{number: "18", marked: false},
        %Number{number: "8", marked: false},
        %Number{number: "23", marked: false},
        %Number{number: "26", marked: false},
        %Number{number: "20", marked: false}
      ],
      [
        %Number{number: "22", marked: false},
        %Number{number: "11", marked: false},
        %Number{number: "13", marked: false},
        %Number{number: "6", marked: false},
        %Number{number: "5", marked: false}
      ],
      [
        %Number{number: "2", marked: false},
        %Number{number: "0", marked: false},
        %Number{number: "12", marked: false},
        %Number{number: "3", marked: false},
        %Number{number: "7", marked: false}
      ]
    ],
    bingo: false
  }

  describe "new/1" do
    test "parses board" do
      input = [
        "14 21 17 24  4",
        "10 16 15  9 19",
        "18  8 23 26 20",
        "22 11 13  6  5",
        "2  0 12  3  7"
      ]

      expected_board = @board_example

      assert ^expected_board = Board.new(input)
    end
  end

  describe "apply_number/2" do
    test "applies number" do
      number = "12"

      expected_board = %Board{
        board: [
          [
            %Number{number: "14", marked: false},
            %Number{number: "21", marked: false},
            %Number{number: "17", marked: false},
            %Number{number: "24", marked: false},
            %Number{number: "4", marked: false}
          ],
          [
            %Number{number: "10", marked: false},
            %Number{number: "16", marked: false},
            %Number{number: "15", marked: false},
            %Number{number: "9", marked: false},
            %Number{number: "19", marked: false}
          ],
          [
            %Number{number: "18", marked: false},
            %Number{number: "8", marked: false},
            %Number{number: "23", marked: false},
            %Number{number: "26", marked: false},
            %Number{number: "20", marked: false}
          ],
          [
            %Number{number: "22", marked: false},
            %Number{number: "11", marked: false},
            %Number{number: "13", marked: false},
            %Number{number: "6", marked: false},
            %Number{number: "5", marked: false}
          ],
          [
            %Number{number: "2", marked: false},
            %Number{number: "0", marked: false},
            %Number{number: "12", marked: true},
            %Number{number: "3", marked: false},
            %Number{number: "7", marked: false}
          ]
        ],
        bingo: false
      }

      assert ^expected_board = Board.apply_number(@board_example, number)
    end
  end

  describe "bingo?/1" do
    test "with a board that has horizontal bingo" do
      board = [
        [
          %Number{number: "14", marked: false},
          %Number{number: "21", marked: false},
          %Number{number: "17", marked: false},
          %Number{number: "24", marked: false},
          %Number{number: "4", marked: false}
        ],
        [
          %Number{number: "10", marked: false},
          %Number{number: "16", marked: false},
          %Number{number: "15", marked: false},
          %Number{number: "9", marked: false},
          %Number{number: "19", marked: false}
        ],
        [
          %Number{number: "18", marked: false},
          %Number{number: "8", marked: false},
          %Number{number: "23", marked: false},
          %Number{number: "26", marked: false},
          %Number{number: "20", marked: false}
        ],
        [
          %Number{number: "22", marked: false},
          %Number{number: "11", marked: false},
          %Number{number: "13", marked: false},
          %Number{number: "6", marked: false},
          %Number{number: "5", marked: false}
        ],
        [
          %Number{number: "2", marked: true},
          %Number{number: "0", marked: true},
          %Number{number: "12", marked: true},
          %Number{number: "3", marked: true},
          %Number{number: "7", marked: true}
        ]
      ]

      assert %Board{board: ^board, bingo: true} = Board.bingo?(%Board{board: board, bingo: false})
    end

    test "with a board that has vertigal bingo" do
      board = [
        [
          %Number{number: "14", marked: false},
          %Number{number: "21", marked: false},
          %Number{number: "17", marked: true},
          %Number{number: "24", marked: false},
          %Number{number: "4", marked: false}
        ],
        [
          %Number{number: "10", marked: false},
          %Number{number: "16", marked: false},
          %Number{number: "15", marked: true},
          %Number{number: "9", marked: false},
          %Number{number: "19", marked: false}
        ],
        [
          %Number{number: "18", marked: false},
          %Number{number: "8", marked: false},
          %Number{number: "23", marked: true},
          %Number{number: "26", marked: false},
          %Number{number: "20", marked: false}
        ],
        [
          %Number{number: "22", marked: false},
          %Number{number: "11", marked: false},
          %Number{number: "13", marked: true},
          %Number{number: "6", marked: false},
          %Number{number: "5", marked: false}
        ],
        [
          %Number{number: "2", marked: false},
          %Number{number: "0", marked: false},
          %Number{number: "12", marked: true},
          %Number{number: "3", marked: false},
          %Number{number: "7", marked: false}
        ]
      ]

      assert %Board{board: ^board, bingo: true} = Board.bingo?(%Board{board: board, bingo: false})
    end

    test "with board that already bingoed" do
      board = %{board: [], bingo: true}

      assert ^board = Board.bingo?(board)
    end

    test "with a board that does not have bingo" do
      expected_board = @board_example

      assert ^expected_board = Board.bingo?(@board_example)
    end
  end
end
