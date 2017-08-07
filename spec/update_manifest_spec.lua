describe("update_manifest", function()
  setup(function()
    io.output("src/update_init.lua")
    io.write("local update_init = { force = false, setfactory = false }")

    require("spec/nodemcu_stubs")
    require("update_manifest")
  end)

  teardown(function()
    os.remove("src/update_init.lua")
  end)

  it("works", function()
    assert.is_true(true)
  end)
end)