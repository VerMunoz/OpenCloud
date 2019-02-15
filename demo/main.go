package main
import (
	"net/http"
	"fmt"
	"time"
	"html/template"
)

type Welcome struct {
	Name string
	Time string
}

func main() {
	welcome := Welcome{" Pedro :D ", time.Now().Format(time.Stamp)}

	templates := template.Must(template.ParseFiles("templates/welcome-template.html"))
	http.Handle("/static/", //final url can be anything
		http.StripPrefix("/static/",
			http.FileServer(http.Dir("static")))) //Go looks in the relative static directory first, then matches it to a

	http.HandleFunc("/" , func(w http.ResponseWriter, r *http.Request) {

		if name := r.FormValue("name"); name != "" {
			welcome.Name = name;
		}
		if err := templates.ExecuteTemplate(w, "welcome-template.html", welcome); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	})

	fmt.Println("Listening on Port 80");
	fmt.Println(http.ListenAndServe(":80", nil));
}
