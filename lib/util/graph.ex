defmodule Aoc24.Util.Graph do
  @type distance_map :: %{any() => number()}
  @type edges :: %{any() => {any(), number()}}
  @type node_queue :: %{any() => number()}

  @spec dijkstras(
          any(),
          edges()
        ) :: %{any() => number()}
  def dijkstras(start, edges) do
    distances =
      Enum.reduce(edges, Map.new(), fn {source, destinations}, acc ->
        all_dests = Enum.map(destinations, fn {point, _weight} -> point end)

        all_dests
        |> Enum.reduce(acc, fn dest, inner_acc -> Map.put_new(inner_acc, dest, :infinity) end)
        |> Map.put_new(source, :infinity)
      end)
      |> Map.put(start, 0)

    queue = %{start => 0}
    dijkstras(distances, edges, queue)
  end

  @spec dijkstras(distance_map(), edges(), node_queue()) :: distance_map()
  defp dijkstras(distances, _, queue) when map_size(queue) == 0 do
    distances
  end

  @spec dijkstras(distance_map(), edges(), node_queue()) :: distance_map()
  defp dijkstras(distances, edges, queue) do
    {cur_point, cur_distance} = Enum.min_by(queue, fn {_, dist} -> dist end)
    queue = Map.delete(queue, cur_point)
    neighbors = Map.get(edges, cur_point, [])

    {new_distances, new_queue} =
      Enum.reduce(neighbors, {distances, queue}, fn {neighbor, weight}, {dist_acc, queue_acc} ->
        new_dist = cur_distance + weight

        if new_dist < Map.get(dist_acc, neighbor, :infinity) do
          {
            Map.put(dist_acc, neighbor, new_dist),
            Map.put(queue_acc, neighbor, new_dist)
          }
        else
          {dist_acc, queue_acc}
        end
      end)

    dijkstras(new_distances, edges, new_queue)
  end
end
