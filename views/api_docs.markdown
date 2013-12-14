###	api


#### show api docs as html

*	method: `GET`
*	type: `HTML`
*	url: `/api/html`


#### show api docs as json

*	method: `GET`
*	type: `JSON`
*	url: `/api/json`


###	galleries


#### show all galleries

*	method: `GET`
*	type: `HTML`
*	url: `/`, `/galleries/html`


#### create a new gallery

*	method: `POST`
*	type: `JSON`
*	url: `/galleries`


#### show all shows from specific gallery based on ID

*	method: `GET`
*	type: `JSON`
*	url: `/galleries/:gallery_id/shows`, `/:gallery_id/shows/json`


#### show all shows from specific gallery based on ID as html

*	method: `GET`
*	type: `html`
*	url: `/galleries/:gallery_id/shows/html`


#### show all shows from specific gallery based on ID as iCalendar

*	method: `GET`
*	type: `iCalendar`
*	url: `/galleries/:gallery_id/ics`


#### show a specific gallery based on its id

*	method: `GET`
*	type: `JSON`
*	url: `/galleries/:gallery_id`, `/galleries/:gallery_id/json`


#### show a specific gallery based on its id as html

*	method: `GET`
*	type: `html`
*	url: `/galleries/:gallery_id/html`


#### update a gallery

*	method: `POST`
*	type: `JSON`
*	url: `/galleries/:gallery_id`


#### delete a gallery

*	method: `DELETE`
*	type: `JSON`
*	url: `/galleries/:gallery_id/delete`


###	shows


#### show all shows

*	method: `GET`
*	type: `json`
*	url: `/shows`, `/shows/json`


#### show all shows as html

*	method: `GET`
*	type: `html`
*	url: `/shows/html`


#### show all shows as iCalendar

*	method: `GET`
*	type": `iCalendar`
*	"url": `/shows/ics`


#### create a new show (at a gallery`

*	method: `POST`
*	type: `JSON`
*	url: `/galleries/:gallery_id/shows`


#### show a specific show based on its id

*	method: `GET`
*	type: `JSON`
*	url: `/shows/:show_id`, `/shows/:show_id/json`


#### show a specific show based on its id as html

*	method: `GET`
*	type: `html`
*	url: `/shows/:show_id/html`


#### update a show

*	method: `POST`
*	type: `JSON`
*	url: `/show/:show_id`


#### delete a show

*	method: `DELETE`
*	type: `JSON`
*	url: `/shows/:show_id/delete`