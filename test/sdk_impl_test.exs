defmodule SdkImplTest do
  use ExUnit.Case
  doctest SdkImpl

  test "greets the world" do
    assert SdkImpl.hello() == :world
  end
end
