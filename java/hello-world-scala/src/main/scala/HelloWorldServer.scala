// src/main/scala/HelloWorldServer.scala

import akka.actor.typed.ActorSystem
import akka.actor.typed.scaladsl.Behaviors
import akka.http.scaladsl.Http
import akka.http.scaladsl.server.Directives._
import org.json4s._
import org.json4s.jackson.JsonMethods._
import scala.io.Source

import scala.io.StdIn

object HelloWorldServer {

  def main(args: Array[String]): Unit = {
    // Create an ActorSystem
    implicit val system = ActorSystem(Behaviors.empty, "helloWorldSystem")
    implicit val executionContext = system.executionContext

    // Define the route
    val route =
    concat(
      path("greet" / Segment) { person =>
        get {
          complete(s"Hello, $person!")
        }
      },
      path("sort"){
        get{
          val source = Source.fromFile("/workspaces/languages-barent/java/hello-world-scala/src/main/scala/test.json")
          val jsonString = try source.mkString finally source.close()
          val json = parse(jsonString)
          val sortedjson = sortJsonByKey(json)
          complete(pretty(render(sortedjson)))
        }
      } ~
      pathSingleSlash{
        get{
          complete(s"This is the root, try something like localhost:8080/greet/{VALUE}")
        }
      }
    )

    // Start the server
    val bindingFuture = Http().newServerAt("localhost", 8080).bind(route)

    println("Server online at http://localhost:8080/\nPress RETURN to stop...")
    StdIn.readLine() // Keep the server running until user presses return
    bindingFuture
      .flatMap(_.unbind()) // Unbind from the port
      .onComplete(_ => system.terminate()) // Terminate the system when done
  }
  def sortJsonByKey(json: JValue): JValue = json match {
    case JObject(fields) => 
      // Sort fields alphabetically by key and recursively apply sorting
      JObject(fields.sortBy(_._1).map { case (k, v) => (k, sortJsonByKey(v)) })
    case JArray(items) =>
      // For arrays, recursively apply sorting to each element
      JArray(items.map(sortJsonByKey))
    case other =>
      // For any other type (string, number, boolean, etc.), return as is
      other
  }
}
