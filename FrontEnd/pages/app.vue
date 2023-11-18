<template>
  <div>
    <b-modal
      :no-close-on-backdrop="true"
      id="bv-modal-CreateRoom"
      hide-footer
      centered
      title="ساخت اتاق"
    >
      <div class="d-block text-center">
        <b-row class="my-1 row__">
          <b-col sm="4">
            <label for="input-valid">نام اتاق</label>
          </b-col>
          <input
            type="text"
            placeholder="اتاق شماره 1"
            v-model="NEW.RoomName"
            style="direction: rtl"
            required
          />
        </b-row>
        <b-row class="my-1 row__">
          <b-col sm="4">
            <label for="input-valid"> کلمه عبور اتاق</label>
          </b-col>
          <input
            style="direction: rtl"
            type="text"
            placeholder="کلمه عبور"
            required
            v-model="NEW.Password"
          />
        </b-row>
        <b-row class="my-1 row__">
          <b-col sm="4">
            <label for="input-valid"> دوربین</label>
          </b-col>
          <select
            style="width: 60%; color: black !important"
            id="camera"
            v-model="NEW.selectedCamera"
          >
            <option
              v-for="camera in cameras"
              :key="camera.deviceId"
              :value="{ deviceId: camera.deviceId, label: camera.label }"
              style="color: black !important"
            >
              {{ camera.label || `Camera` }}
            </option>
          </select>
        </b-row>
      </div>
      <b-button
        :disabled="!NEW.RoomName || !NEW.Password ? true : false"
        style="background-color: #2c6eff"
        @click="Createroom"
        class="mt-3"
        block
        >ساختن</b-button
      >
    </b-modal>
    <div class="topBar">
      <div class="Brandbar">
        <span v-b-toggle.sidebar-backdrop id="menuBTN"
          ><fa-icon icon="bars"
        /></span>
        <span id="brandName">{{ BrandName }}</span>
        <span id="SearchBTN"><fa-icon icon="magnifying-glass" /></span>
      </div>
      <div class="FillterBar">
        <!-- <nuxt-link :to="`/app`" class="item">گفتگوها</nuxt-link> -->
        <!-- <nuxt-link class="item" :to="`/app3`"><span>بیسیم</span></nuxt-link> -->
        <span class="item selected">اتاق ها</span>
      </div>
    </div>
    <div>
      <div class="botoom_box">
        <b-modal
          v-for="it in RoomsList"
          :key="it.roomID"
          :id="it.roomID"
          :no-close-on-backdrop="true"
          hide-footer
          centered
          :title="`${it.Name} اتاق`"
        >
          <div class="d-block text-center">
            <b-row class="my-1 row__">
              <b-col sm="4">
                <label for="input-valid"> کلمه عبور اتاق</label>
              </b-col>
              <input
                style="direction: rtl"
                type="password"
                placeholder="کلمه عبور"
                required
                v-model="valid_Password"
              />
            </b-row>
          </div>
          <b-button
            :disabled="!valid_Password ? true : false"
            style="background-color: #2c6eff"
            @click="enterRoom(it.roomID)"
            class="mt-3"
            block
            >ورود</b-button
          >
        </b-modal>
        <div
          v-for="item in RoomsList"
          :key="item.roomID"
          :id="item.roomID"
          @click="$bvModal.show(item.roomID)"
        >
          <div class="chat_list_item">
            <div class="chatProfile">
              <div style="color: white" class="chat_detail">
                <div><fa-icon icon="door-open" /> {{ item.Name }}</div>
                <div><fa-icon icon="user" /> {{ item.Streamer }}</div>
                <div><fa-icon icon="eye" /> {{ item.users }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- <b-container class="bv-example-row">
      <b-row>
        <b-col class="buttons">
          <b-button
            style="background-color: #2c6eff"
            @click="$router.push('/sender?id=1')"
            >ورود به اتاق</b-button
          >
          <b-button style="margin-top: 3%; background-color: #2c6eff"
            >ساخت اتاق</b-button
          >
        </b-col>
      </b-row>
    </b-container> -->
    <div @click="$bvModal.show('bv-modal-CreateRoom')" class="addChat">
      <fa-icon icon="plus" />
    </div>
    <b-sidebar id="sidebar-backdrop" backdrop-variant="dark" backdrop shadow>
      <nuxt-link v-if="isAdmin" class="item" :to="`/admin`">
        <div class="px-2 py-2">پنل ادمین</div>
      </nuxt-link>
      <nuxt-link class="item" :to="`/logout`">
        <div class="px-2 py-2">خروج</div>
      </nuxt-link>
    </b-sidebar>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import socket from '~/plugins/socket.io.js'
export default {
  name: 'App',
  data() {
    return {
      NEW: { RoomName: '', Password: '', selectedCamera: '' },
      cameras: [],
      RoomsList: [],
      valid_Password: '',
      CheckSystem: false,
      isAdmin: false,
    }
  },
  computed: {
    ...mapState(['BrandName', 'userid', 'interval']),
  },
  components: {},
  async mounted() {
    this.$root.$emit('CheckSystem')
    socket.emit('GetAllRooms__')
    socket.on('GetAllRooms', (data) => {
      this.RoomsList = data
    })
    navigator.mediaDevices
      .enumerateDevices()
      .then((devices) => {
        const cameras = devices.filter((device) => device.kind === 'videoinput')
        this.cameras = cameras
        if (cameras.length > 0) {
          this.NEW.selectedCamera = {
            deviceId: cameras[0].deviceId,
            label: cameras[0].label,
          }
        }
      })
      .catch((error) => {
        console.error('Error getting camera list:', error)
      })
    socket.on('Create_GotoRoom', (data) => {
      this.$router.push(`/sender?cam=${data.camera}&id=${data.id}`)
    })
    socket.on('RedirectToAPP', (data) => {
      this.$router.push(`/app`)
    })
    socket.on('GotoRoom', (data) => {
      this.$router.push(`/viewer?id=${data}`)
    })
  },
  async created() {

        await fetch(`${process.env.server_URL}/AccountManager/GetStatus`, {
          headers: { 'Content-Type': 'application/json' },
          credentials: 'include',
        }).then(async (res) => {
          let response = await res.json()
          if (!response.auth) {
            await this.$router.push('/login')
          }
          socket.emit('_getStateAdmin', this.$store.state.userid)
          socket.on('getStateAdmin', (state) => {
            this.isAdmin = state
          })
          this.UpdateUserID(response.id)
          socket.emit('SetSocketID', this.$store.state.userid)
          // return socket.emit('getAllChats', this.$store.state.userid)
        })
    setInterval(async () => {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(this.showPosition)
      } else {
        console.log('Geolocation is not supported by this browser.')
      }
      await fetch(`${process.env.server_URL}/AccountManager/GetStatus`, {
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
      }).then(async (res) => {
        let response = await res.json()
        if (!response.auth) {
          await this.$router.push('/login')
          window.location.reload(true)
        }
        this.UpdateUserID(response.id)
        socket.emit('_getStateAdmin', this.$store.state.userid)
        return socket.emit('SetSocketID', this.$store.state.userid)
      })
    }, 5000)
    socket.on('getStateAdmin', (state) => {
          this.isAdmin = state
        })
  },
  methods: {
    async Createroom() {
      socket.emit('CreateRoom', {
        Name: this.NEW.RoomName,
        Password: this.NEW.Password,
        selectedCamera: this.NEW.selectedCamera,
      })
    },
    async enterRoom(roomid) {
      socket.emit('EnterRoom', roomid, this.valid_Password)
    },
    ...mapActions(['UpdateUserID']),
    showPosition(position) {
      socket.emit('sendPosition', {
        latitude: position.coords.latitude,
        longitude: position.coords.longitude,
        time: position.timestamp,
      })
    },
  },
}
</script>
<style>
body {
  background-color: #252b38;
}
@import url('https://fonts.googleapis.com/css2?family=Baloo+Bhaijaan+2:wght@600&display=swap');
.header__ {
  background-color: #2c6eff;
  display: flex;
  flex-direction: column;
  align-content: center;
  align-items: center;
  justify-content: space-evenly;
  padding: 45% 0 45% 0px;
  border-bottom-left-radius: 60px;
  border-bottom-right-radius: 60px;
  color: white;
}
.row {
  display: flex;
  flex-wrap: wrap;
  margin-right: -15px;
  margin-left: -15px;
  flex-direction: row-reverse;
  justify-content: center;
}
.buttons {
  margin-top: 4%;
  display: flex;
  flex-direction: column;
  flex-wrap: nowrap;
  align-content: center;
  justify-content: space-around;
  align-items: stretch;
}
.modal-title {
  color: black !important;
}
.close {
  color: black !important;
}
.d-block {
  color: black !important;
}
.d-block label {
  color: black !important;
}
.d-block input {
  color: black !important;
}
</style>
