defmodule Letzell.Workers.ProcessListing do
  use GenServer
  alias Letzell.Workers.CreateListing

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    # Call Jooble, Adzuna, Themuse, Remotive
    # ...
    CreateListing.run()

    # Reschedule once more
    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 2 hours (written in milliseconds).
    # Alternatively, one might write :timer.hours(2)
    Process.send_after(self(), :work, 5000)
  end
end
